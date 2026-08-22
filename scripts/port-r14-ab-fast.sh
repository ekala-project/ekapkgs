#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r14-ab-results.log"
: > "$RESULTS"

cd "$EKAPKGS"

prep_pkg() {
    local PKG="$1"
    local PREFIX="${PKG:0:2}"
    local SRC_DIR="$NIXPKGS/pkgs/by-name/$PREFIX/$PKG"
    local DEST_DIR="$EKAPKGS/pkgs/$PKG"

    [ -d "$DEST_DIR" ] && rm -rf "$DEST_DIR"
    [ ! -f "$SRC_DIR/package.nix" ] && return 1

    mkdir -p "$DEST_DIR"
    cp "$SRC_DIR/package.nix" "$DEST_DIR/default.nix"
    for f in "$SRC_DIR"/*; do
        base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$DEST_DIR/$base"
    done

    local NIXFILE="$DEST_DIR/default.nix"
    sed -i '/^\s*nix-update-script\s*,\?\s*$/d' "$NIXFILE"
    sed -i '/versionCheckHook/d' "$NIXFILE"
    sed -i '/passthru\.updateScript/d' "$NIXFILE"
    perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\s*\n/\n/g' "$NIXFILE"
    sed -i '/nixosTests/d' "$NIXFILE"
    perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$NIXFILE"

    if grep -qw 'cmake' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            sed -i '/^[[:space:]]*cmake[[:space:]]*$/{
                a\    cmake.configurePhaseHook
            }' "$NIXFILE"
        fi
    fi

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

    $NIXFMT "$NIXFILE" 2>/dev/null || true
    return 0
}

build_and_commit() {
    local PKG="$1"
    local DEST_DIR="$EKAPKGS/pkgs/$PKG"

    # Use timeout command to limit total build time to 10 min
    if ! timeout 660 nix-build -A "$PKG" --no-out-link --timeout 600 >/dev/null 2>&1; then
        echo "FAIL:BUILD $PKG" | tee -a "$RESULTS"
        rm -rf "$DEST_DIR"
        return 1
    fi

    local VERSION
    VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")

    git add "pkgs/$PKG/"
    for attempt in 1 2 3 4 5; do
        if git commit -m "$PKG: init at $VERSION" --quiet 2>/dev/null; then
            echo "OK $PKG $VERSION" | tee -a "$RESULTS"
            return 0
        fi
        sleep $((attempt * 2))
    done

    echo "FAIL:COMMIT $PKG" | tee -a "$RESULTS"
    git reset HEAD -- "pkgs/$PKG/" 2>/dev/null
    rm -rf "$DEST_DIR"
    return 1
}

# Phase 1: Prep all + eval
echo "=== Phase 1: Prep + Eval ==="
EVAL_OK=()
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue

    # Skip if already committed
    if git log --oneline --all -- "pkgs/$pkg/default.nix" | head -1 | grep -q "init at" 2>/dev/null; then
        echo "SKIP:COMMITTED $pkg" | tee -a "$RESULTS"
        continue
    fi

    if ! prep_pkg "$pkg"; then
        echo "SKIP:NOSRC $pkg" | tee -a "$RESULTS"
        continue
    fi

    if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
        EVAL_OK+=("$pkg")
        echo "EVAL:OK $pkg"
    else
        echo "FAIL:EVAL $pkg" | tee -a "$RESULTS"
        rm -rf "$EKAPKGS/pkgs/$pkg"
    fi
done < /tmp/r14-batch-ab

echo ""
echo "Packages passing eval: ${#EVAL_OK[@]}"
echo ""

# Phase 2: Estimate complexity (sort by dep count)
echo "=== Phase 2: Sort by complexity ==="
declare -A DEP_COUNT
for pkg in "${EVAL_OK[@]}"; do
    drv=$(nix-instantiate -A "$pkg" 2>/dev/null)
    if [ -n "$drv" ]; then
        count=$(nix-store -qR "$drv" 2>/dev/null | wc -l)
        DEP_COUNT[$pkg]=$count
        echo "$pkg: $count deps"
    else
        DEP_COUNT[$pkg]=9999
    fi
done

# Sort packages by dep count (ascending)
SORTED_PKGS=()
while IFS= read -r line; do
    SORTED_PKGS+=("$line")
done < <(for pkg in "${EVAL_OK[@]}"; do echo "${DEP_COUNT[$pkg]} $pkg"; done | sort -n | awk '{print $2}')

echo ""
echo "Build order (${#SORTED_PKGS[@]} packages):"
for pkg in "${SORTED_PKGS[@]}"; do
    echo "  ${DEP_COUNT[$pkg]} deps: $pkg"
done

# Phase 3: Build in order of complexity
echo ""
echo "=== Phase 3: Build ==="
for pkg in "${SORTED_PKGS[@]}"; do
    echo "BUILD: $pkg (${DEP_COUNT[$pkg]} deps)"
    build_and_commit "$pkg"
done

echo ""
echo "=== SUMMARY ==="
echo "OK: $(grep -c '^OK' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:EVAL: $(grep -c '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:BUILD: $(grep -c '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo 0)"
echo "SKIP: $(grep -c '^SKIP' "$RESULTS" 2>/dev/null || echo 0)"
