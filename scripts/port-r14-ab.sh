#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r14-ab-results.log"
> "$RESULTS"

cd "$EKAPKGS"

process_pkg() {
    local PKG="$1"
    local PREFIX="${PKG:0:2}"
    local SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
    local DEST_DIR="$EKAPKGS/pkgs/$PKG"

    # Check if already committed
    if git log --oneline | grep -q " $PKG: init at" 2>/dev/null; then
        echo "SKIP:COMMITTED $PKG" >> "$RESULTS"
        return 0
    fi

    # Clean up if exists
    [ -d "$DEST_DIR" ] && rm -rf "$DEST_DIR"

    # Check source
    if [ ! -f "$SRC_DIR/package.nix" ]; then
        echo "SKIP:NOSRC $PKG" >> "$RESULTS"
        return 0
    fi

    # Create dest + copy files
    mkdir -p "$DEST_DIR"
    cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"
    for f in "$SRC_DIR"/*; do
        local base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$DEST_DIR/$base"
    done

    local NIXFILE="$DEST_DIR/default.nix"

    # --- Transforms ---

    # Remove nix-update-script from inputs
    sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NIXFILE"

    # Remove versionCheckHook
    sed -i '/versionCheckHook/d' "$NIXFILE"

    # Remove passthru.updateScript lines
    sed -i '/passthru\.updateScript/d' "$NIXFILE"

    # Remove empty passthru blocks
    perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NIXFILE"

    # Remove nixosTests references
    sed -i '/nixosTests/d' "$NIXFILE"

    # Set maintainers = [ ]
    perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$NIXFILE"

    # cmake: add configurePhaseHook
    if grep -qw 'cmake' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            sed -i '/^[[:space:]]*cmake[[:space:]]*$/{
                a\    cmake.configurePhaseHook
            }' "$NIXFILE"
        fi
    fi

    # meson: add configurePhaseHook + ninja
    if grep -qw 'meson' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'meson\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            sed -i '/^[[:space:]]*meson[[:space:]]*$/{
                a\    meson.configurePhaseHook
            }' "$NIXFILE"
        fi
        if ! grep -qw 'ninja' "$NIXFILE" 2>/dev/null; then
            sed -i '/meson\.configurePhaseHook/a\    ninja' "$NIXFILE"
        fi
    fi

    # Format
    $NIXFMT "$NIXFILE" 2>/dev/null || true

    # Evaluate
    if ! nix-instantiate -A "$PKG" >/dev/null 2>&1; then
        echo "FAIL:EVAL $PKG" >> "$RESULTS"
        rm -rf "$DEST_DIR"
        return 1
    fi

    # Build with timeout
    if ! nix-build -A "$PKG" --timeout 600 --no-out-link >/dev/null 2>&1; then
        echo "FAIL:BUILD $PKG" >> "$RESULTS"
        rm -rf "$DEST_DIR"
        return 1
    fi

    # Extract version
    local VERSION
    VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")

    # Commit with retry for git lock
    git add "pkgs/$PKG/"
    local retries=0
    while ! git commit -m "$PKG: init at $VERSION" --quiet 2>/dev/null; do
        retries=$((retries+1))
        if [ $retries -gt 5 ]; then
            echo "FAIL:COMMIT $PKG" >> "$RESULTS"
            rm -rf "$DEST_DIR"
            return 1
        fi
        sleep $((retries * 2))
    done

    echo "OK $PKG $VERSION" >> "$RESULTS"
    echo "OK $PKG $VERSION"
    return 0
}

while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    echo ">>> $pkg"
    process_pkg "$pkg" || true
done < /tmp/r14-batch-ab
