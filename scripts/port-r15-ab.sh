#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r15-ab-results.log"
: > "$RESULTS"

cd "$EKAPKGS"

process_one() {
    local PKG="$1"
    local PREFIX="${PKG:0:2}"
    local SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
    local DEST_DIR="$EKAPKGS/pkgs/$PKG"

    # Skip if already committed
    if git log --oneline -1 -- "pkgs/$PKG/default.nix" 2>/dev/null | grep -q "init at"; then
        echo "SKIP:COMMITTED $PKG" >> "$RESULTS"
        return 0
    fi

    # Skip if already exists (from a prior batch)
    if [ -d "$DEST_DIR" ]; then
        echo "SKIP:EXISTS $PKG" >> "$RESULTS"
        return 0
    fi

    [ ! -f "$SRC_DIR/package.nix" ] && { echo "SKIP:NOSRC $PKG" >> "$RESULTS"; return 0; }

    mkdir -p "$DEST_DIR"
    cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"
    for f in "$SRC_DIR"/*; do
        local base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$DEST_DIR/$base"
    done

    local NF="$DEST_DIR/default.nix"

    # Remove nix-update-script from inputs
    sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NF"

    # Remove versionCheckHook references
    sed -i '/versionCheckHook/d' "$NF"

    # Remove passthru.updateScript lines
    sed -i '/passthru\.updateScript/d' "$NF"

    # Remove empty passthru blocks
    perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NF"

    # Remove nixosTests references
    sed -i '/nixosTests/d' "$NF"

    # Set maintainers = [ ]
    perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$NF"

    # Also handle lib.teams.*.members
    sed -i 's/maintainers = lib\.teams\.[a-zA-Z0-9_-]*\.members/maintainers = [ ]/' "$NF"

    # cmake hook
    if grep -qw 'cmake' "$NF" 2>/dev/null; then
        if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NF" 2>/dev/null; then
            perl -i -pe 's/^(\s*)cmake\s*$/$1cmake\n$1cmake.configurePhaseHook/' "$NF"
            sed -i 's/\[ cmake \]/[ cmake cmake.configurePhaseHook ]/' "$NF"
        fi
    fi

    # meson hook
    if grep -qw 'meson' "$NF" 2>/dev/null; then
        if ! grep -q 'meson\.configurePhaseHook' "$NF" 2>/dev/null; then
            perl -i -pe 's/^(\s*)meson\s*$/$1meson\n$1meson.configurePhaseHook/' "$NF"
            sed -i 's/\[ meson \]/[ meson meson.configurePhaseHook ]/' "$NF"
        fi
        if ! grep -qw 'ninja' "$NF" 2>/dev/null; then
            sed -i '/meson\.configurePhaseHook/a\    ninja' "$NF"
        fi
    fi

    $NIXFMT "$NF" 2>/dev/null || true

    # Eval
    if ! nix-instantiate -A "$PKG" >/dev/null 2>&1; then
        echo "FAIL:EVAL $PKG" >> "$RESULTS"
        rm -rf "$DEST_DIR"
        return 1
    fi

    # Build with timeout
    if ! timeout 660 nix-build -A "$PKG" --no-out-link --timeout 600 >/dev/null 2>&1; then
        echo "FAIL:BUILD $PKG" >> "$RESULTS"
        rm -rf "$DEST_DIR"
        return 1
    fi

    local VERSION
    VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")

    git add "pkgs/$PKG/"
    if git commit -m "$PKG: init at $VERSION" 2>/dev/null; then
        echo "OK $PKG $VERSION" | tee -a "$RESULTS"
    else
        echo "FAIL:COMMIT $PKG" >> "$RESULTS"
        git reset HEAD -- "pkgs/$PKG/" 2>/dev/null
        rm -rf "$DEST_DIR"
        return 1
    fi
}

while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    echo ">>> $pkg"
    process_one "$pkg" || true
done < /tmp/r15-batch-ab

echo ""
echo "=== FINAL SUMMARY ==="
echo "OK: $(grep -c '^OK' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:EVAL: $(grep -c '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:BUILD: $(grep -c '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:COMMIT: $(grep -c '^FAIL:COMMIT' "$RESULTS" 2>/dev/null || echo 0)"
echo "SKIP: $(grep -c '^SKIP' "$RESULTS" 2>/dev/null || echo 0)"
echo "---"
echo "Failed evals:"
grep '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo "(none)"
echo "---"
echo "Failed builds:"
grep '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo "(none)"
echo "---"
echo "Successful packages:"
grep '^OK' "$RESULTS" 2>/dev/null || echo "(none)"
