#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r14-ab-results.log"
> "$RESULTS"

cd "$EKAPKGS"

prep_pkg() {
    local PKG="$1"
    local PREFIX="${PKG:0:2}"
    local SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
    local DEST_DIR="$EKAPKGS/pkgs/$PKG"

    # Clean up if exists
    [ -d "$DEST_DIR" ] && rm -rf "$DEST_DIR"

    # Check source
    if [ ! -f "$SRC_DIR/package.nix" ]; then
        return 1
    fi

    # Create dest + copy files
    mkdir -p "$DEST_DIR"
    cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"
    for f in "$SRC_DIR"/*; do
        local base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$DEST_DIR/$base"
    done

    local NIXFILE="$DEST_DIR/default.nix"

    # Remove nix-update-script
    sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NIXFILE"
    # Remove versionCheckHook
    sed -i '/versionCheckHook/d' "$NIXFILE"
    # Remove passthru.updateScript
    sed -i '/passthru\.updateScript/d' "$NIXFILE"
    # Remove empty passthru
    perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NIXFILE"
    # Remove nixosTests
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
    return 0
}

# Phase 1: Prep all packages
echo "=== Phase 1: Prep ==="
PKGS_TO_EVAL=()
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    # Check if already committed
    if git log --oneline | grep -q " $pkg: init at" 2>/dev/null; then
        echo "SKIP:COMMITTED $pkg" >> "$RESULTS"
        continue
    fi
    if prep_pkg "$pkg"; then
        PKGS_TO_EVAL+=("$pkg")
    else
        echo "SKIP:NOSRC $pkg" >> "$RESULTS"
    fi
done < /tmp/r14-batch-ab
echo "Prepped ${#PKGS_TO_EVAL[@]} packages"

# Phase 2: Eval all packages
echo "=== Phase 2: Eval ==="
PKGS_TO_BUILD=()
for pkg in "${PKGS_TO_EVAL[@]}"; do
    if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
        PKGS_TO_BUILD+=("$pkg")
        echo "EVAL:OK $pkg"
    else
        echo "FAIL:EVAL $pkg" >> "$RESULTS"
        rm -rf "$EKAPKGS/pkgs/$pkg"
        echo "EVAL:FAIL $pkg"
    fi
done
echo "Eval passed: ${#PKGS_TO_BUILD[@]} packages"

# Phase 3: Build + commit each
echo "=== Phase 3: Build ==="
for pkg in "${PKGS_TO_BUILD[@]}"; do
    echo "BUILD: $pkg"
    if nix-build -A "$pkg" --timeout 600 --no-out-link >/dev/null 2>&1; then
        VERSION=$(nix-instantiate --eval -A "$pkg.version" 2>/dev/null | tr -d '"' || echo "unknown")
        git add "pkgs/$pkg/"
        # Retry commit for git lock
        local_ok=false
        for i in 1 2 3 4 5; do
            if git commit -m "$pkg: init at $VERSION" --quiet 2>/dev/null; then
                local_ok=true
                break
            fi
            sleep $((i * 2))
        done
        if $local_ok; then
            echo "OK $pkg $VERSION" >> "$RESULTS"
            echo "OK $pkg $VERSION"
        else
            echo "FAIL:COMMIT $pkg" >> "$RESULTS"
            rm -rf "$EKAPKGS/pkgs/$pkg"
        fi
    else
        echo "FAIL:BUILD $pkg" >> "$RESULTS"
        rm -rf "$EKAPKGS/pkgs/$pkg"
        echo "FAIL:BUILD $pkg"
    fi
done

echo "=== Done ==="
echo "Results:"
grep -c "^OK" "$RESULTS" 2>/dev/null || echo "0"; echo " successes"
grep -c "^FAIL" "$RESULTS" 2>/dev/null || echo "0"; echo " failures"  
grep -c "^SKIP" "$RESULTS" 2>/dev/null || echo "0"; echo " skips"
