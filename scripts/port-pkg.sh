#!/usr/bin/env bash
set -euo pipefail

# Port a single package from nixpkgs to ekapkgs
# Usage: port-pkg.sh <pkg-name>

PKG="$1"
NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
PREFIX="${PKG:0:2}"
SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
DEST_DIR="$EKAPKGS/pkgs/$PKG"

if [ ! -d "$SRC_DIR" ]; then
    echo "SKIP $PKG: source not found at $SRC_DIR"
    exit 1
fi

# Create dest dir
mkdir -p "$DEST_DIR"

# Copy package.nix as default.nix
cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"

# Copy any patch files or other non-nix files
for f in "$SRC_DIR"/*; do
    bn=$(basename "$f")
    if [ "$bn" != "package.nix" ]; then
        cp -r "$f" "$DEST_DIR/"
    fi
done

FILE="$DEST_DIR/default.nix"

# --- Apply transforms ---

# 1. Set meta.maintainers = [ ]
# Handle various forms: maintainers = with lib.maintainers; [ ... ]; and maintainers = [ lib.maintainers.xxx ];
# Use perl for multiline replacements
perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$FILE"
perl -0777 -i -pe 's/maintainers\s*=\s*\[(?:[^\]]*?lib\.maintainers[^\]]*?)\]/maintainers = [ ]/gs' "$FILE"

# 2. Remove passthru.updateScript (can be multiline)
perl -0777 -i -pe 's/\n\s*passthru\.updateScript\s*=\s*[^;]*?;\n/\n/gs' "$FILE"
# Also handle passthru = { updateScript = ... };
perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*updateScript\s*=\s*[^}]*?\};\n/\n/gs' "$FILE"
# Handle passthru block with updateScript among other things
perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\};\n?//gs' "$FILE"
perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\);\n?//gs' "$FILE"
perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*;\n?//gs' "$FILE"

# 3. Remove nixosTests references
perl -0777 -i -pe 's/\s*nixosTests\s*[,]?\s*//g' "$FILE"
# Remove passthru.tests = { inherit nixosTests.xxx; }; type patterns
perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*tests\s*=\s*\{\s*inherit\s+[^}]*\};\s*\};\n/\n/gs' "$FILE"

# 4. Remove versionCheckHook references
sed -i '/versionCheckHook/d' "$FILE"
# Clean up any resulting empty lines or trailing commas in lists

# 5. Remove nix-update-script from inputs
sed -i '/nix-update-script/d' "$FILE"

# 6. Check if it uses cmake and add cmake.configurePhaseHook
if grep -q 'cmake' "$FILE" && grep -q 'nativeBuildInputs' "$FILE"; then
    if ! grep -q 'cmake\.configurePhaseHook' "$FILE"; then
        # Add cmake.configurePhaseHook after cmake in nativeBuildInputs
        perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$FILE"
    fi
fi

# 7. Check if it uses meson and add meson.configurePhaseHook + ensure meson + ninja
if grep -q '\bmeson\b' "$FILE" && grep -q 'nativeBuildInputs' "$FILE"; then
    if ! grep -q 'meson\.configurePhaseHook' "$FILE"; then
        perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$FILE"
    fi
fi

# 8. Remove empty passthru blocks
perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$FILE"

# 9. Clean up double blank lines
sed -i '/^$/N;/^\n$/d' "$FILE"

echo "TRANSFORMED $PKG"
