#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r14-ab-results.log"
: > "$RESULTS"

cd "$EKAPKGS"

while IFS= read -r PKG; do
    [ -z "$PKG" ] && continue
    PREFIX="${PKG:0:2}"
    SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
    DEST_DIR="$EKAPKGS/pkgs/$PKG"

    # Skip if already committed
    if git log --oneline --all -- "pkgs/$PKG/default.nix" | head -1 | grep -q "init at" 2>/dev/null; then
        echo "SKIP:COMMITTED $PKG" | tee -a "$RESULTS"
        continue
    fi

    # Clean old
    [ -d "$DEST_DIR" ] && rm -rf "$DEST_DIR"

    # Check source
    if [ ! -f "$SRC_DIR/package.nix" ]; then
        echo "SKIP:NOSRC $PKG" | tee -a "$RESULTS"
        continue
    fi

    # Copy
    mkdir -p "$DEST_DIR"
    cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"
    for f in "$SRC_DIR"/*; do
        base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$DEST_DIR/$base"
    done

    NIXFILE="$DEST_DIR/default.nix"

    # Transforms
    sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NIXFILE"
    sed -i '/versionCheckHook/d' "$NIXFILE"
    sed -i '/passthru\.updateScript/d' "$NIXFILE"
    perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NIXFILE"
    sed -i '/nixosTests/d' "$NIXFILE"
    perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$NIXFILE"

    # cmake hook
    if grep -qw 'cmake' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            sed -i '/^[[:space:]]*cmake[[:space:]]*$/{
                a\    cmake.configurePhaseHook
            }' "$NIXFILE"
        fi
    fi

    # meson hook
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

    # Eval
    if ! nix-instantiate -A "$PKG" >/dev/null 2>&1; then
        echo "FAIL:EVAL $PKG" | tee -a "$RESULTS"
        rm -rf "$DEST_DIR"
        continue
    fi

    # Build
    if ! nix-build -A "$PKG" --timeout 600 --no-out-link >/dev/null 2>&1; then
        echo "FAIL:BUILD $PKG" | tee -a "$RESULTS"
        rm -rf "$DEST_DIR"
        continue
    fi

    # Version + commit
    VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")
    git add "pkgs/$PKG/"
    committed=false
    for attempt in 1 2 3 4 5; do
        if git commit -m "$PKG: init at $VERSION" --quiet 2>/dev/null; then
            committed=true
            break
        fi
        sleep $((attempt * 2))
    done
    
    if $committed; then
        echo "OK $PKG $VERSION" | tee -a "$RESULTS"
    else
        echo "FAIL:COMMIT $PKG" | tee -a "$RESULTS"
        git reset HEAD -- "pkgs/$PKG/" 2>/dev/null
        rm -rf "$DEST_DIR"
    fi
done < /tmp/r14-batch-ab

echo "=== SUMMARY ==="
echo "OK: $(grep -c '^OK' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:EVAL: $(grep -c '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:BUILD: $(grep -c '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo 0)"
echo "SKIP: $(grep -c '^SKIP' "$RESULTS" 2>/dev/null || echo 0)"
