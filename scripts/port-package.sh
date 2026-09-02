#!/usr/bin/env bash
set -uo pipefail

PKG="$1"
NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
PREFIX="${PKG:0:2}"

SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
DEST_DIR="$EKAPKGS/pkgs/$PKG"

# Check if already committed
if git -C "$EKAPKGS" log --oneline --all | grep -q "^.* $PKG: init at" 2>/dev/null; then
    echo "SKIP:COMMITTED $PKG"
    exit 0
fi

# Check if already exists
if [ -d "$DEST_DIR" ]; then
    rm -rf "$DEST_DIR"
fi

# Check source exists
if [ ! -f "$SRC_DIR/package.nix" ]; then
    echo "SKIP:NOSRC $PKG"
    exit 0
fi

# Create dest dir
mkdir -p "$DEST_DIR"

# Copy package.nix to default.nix
cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"

# Copy any patch files or other non-nix files
for f in "$SRC_DIR"/*; do
    base="$(basename "$f")"
    if [ "$base" != "package.nix" ]; then
        cp -r "$f" "$DEST_DIR/$base"
    fi
done

NIXFILE="$DEST_DIR/default.nix"

# Remove nix-update-script from inputs
sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NIXFILE"

# Remove versionCheckHook from inputs and nativeInstallCheckInputs
sed -i '/^\s*versionCheckHook\s*,\?\s*$/d' "$NIXFILE"

# Remove passthru.updateScript lines
sed -i '/passthru\.updateScript/d' "$NIXFILE"

# Remove passthru block if it only contained updateScript (now empty)
perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NIXFILE"

# Remove nixosTests references
sed -i '/nixosTests/d' "$NIXFILE"

# Set meta.maintainers = [ ] - handle various patterns
perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$NIXFILE"

# Check if cmake is used and add configurePhaseHook
if grep -qw 'cmake' "$NIXFILE" 2>/dev/null; then
    if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
        # Add cmake.configurePhaseHook after standalone cmake line in nativeBuildInputs
        sed -i '/^\(\s\+\)cmake\s*$/{ a\    cmake.configurePhaseHook
}' "$NIXFILE"
    fi
fi

# Check if meson is used and add configurePhaseHook + ninja
if grep -qw 'meson' "$NIXFILE" 2>/dev/null; then
    if ! grep -q 'meson\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
        sed -i '/^\(\s\+\)meson\s*$/{ a\    meson.configurePhaseHook
}' "$NIXFILE"
    fi
    if ! grep -qw 'ninja' "$NIXFILE" 2>/dev/null; then
        sed -i '/meson\.configurePhaseHook/a\    ninja' "$NIXFILE"
    fi
fi

# Format
$NIXFMT "$NIXFILE" 2>/dev/null || true

# Try to evaluate
cd "$EKAPKGS"
EVAL_OUT=$(nix-instantiate -A "$PKG" 2>&1)
if [ $? -ne 0 ]; then
    echo "FAIL:EVAL $PKG"
    echo "$EVAL_OUT" | tail -5
    rm -rf "$DEST_DIR"
    exit 1
fi

# Try to build with timeout
BUILD_OUT=$(nix-build -A "$PKG" --timeout 600 --no-out-link 2>&1)
if [ $? -ne 0 ]; then
    echo "FAIL:BUILD $PKG"
    echo "$BUILD_OUT" | tail -10
    rm -rf "$DEST_DIR"
    exit 1
fi

# Extract version
VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")

# Commit
cd "$EKAPKGS"
git add "pkgs/$PKG/"
git commit -m "$PKG: init at $VERSION" --quiet

echo "OK $PKG $VERSION"
