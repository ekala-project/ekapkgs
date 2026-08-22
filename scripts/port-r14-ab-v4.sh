#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r14-ab-results-v4.log"
LOCKFILE="/tmp/ekapkgs-git.lock"
: > "$RESULTS"

cd "$EKAPKGS"

git_commit_with_lock() {
    local PKG="$1"
    local VERSION="$2"
    local max_attempts=30
    
    for attempt in $(seq 1 $max_attempts); do
        # Try to acquire lock
        if (set -o noclobber; echo $$ > "$LOCKFILE") 2>/dev/null; then
            # Got lock - do git add + commit
            trap "rm -f '$LOCKFILE'" EXIT
            git add "pkgs/$PKG/" 2>/dev/null
            if git commit -m "$PKG: init at $VERSION" 2>/dev/null; then
                rm -f "$LOCKFILE"
                trap - EXIT
                return 0
            else
                # Commit failed - maybe nothing staged or files were removed
                rm -f "$LOCKFILE"
                trap - EXIT
                # Try again without lock
                sleep 1
                continue
            fi
        fi
        # Lock held by someone else, wait
        sleep $((RANDOM % 3 + 1))
    done
    return 1
}

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

    # cmake: add configurePhaseHook - handle both inline and standalone
    if grep -qw 'cmake' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            # standalone cmake on its own line
            perl -i -pe 's/^(\s*)cmake\s*$/$1cmake\n$1cmake.configurePhaseHook/' "$NIXFILE"
            # inline: [ cmake ] or nativeBuildInputs = [ cmake ];
            sed -i 's/\[ cmake \]/[ cmake cmake.configurePhaseHook ]/' "$NIXFILE"
        fi
    fi

    # meson: add configurePhaseHook + ninja
    if grep -qw 'meson' "$NIXFILE" 2>/dev/null; then
        if ! grep -q 'meson\.configurePhaseHook' "$NIXFILE" 2>/dev/null; then
            perl -i -pe 's/^(\s*)meson\s*$/$1meson\n$1meson.configurePhaseHook/' "$NIXFILE"
            sed -i 's/\[ meson \]/[ meson meson.configurePhaseHook ]/' "$NIXFILE"
        fi
        if ! grep -qw 'ninja' "$NIXFILE" 2>/dev/null; then
            sed -i '/meson\.configurePhaseHook/a\    ninja' "$NIXFILE"
        fi
    fi

    $NIXFMT "$NIXFILE" 2>/dev/null || true
    return 0
}

# Read all packages from the batch
readarray -t ALL_PKGS < /tmp/r14-batch-ab

echo "Total packages: ${#ALL_PKGS[@]}"

for PKG in "${ALL_PKGS[@]}"; do
    [ -z "$PKG" ] && continue

    # Check if already committed
    if git log --oneline -- "pkgs/$PKG/default.nix" 2>/dev/null | head -1 | grep -q "init at"; then
        echo "SKIP:COMMITTED $PKG" | tee -a "$RESULTS"
        continue
    fi

    # Prep
    if ! prep_pkg "$PKG"; then
        echo "SKIP:NOSRC $PKG" | tee -a "$RESULTS"
        continue
    fi

    # Eval
    if ! nix-instantiate -A "$PKG" >/dev/null 2>&1; then
        echo "FAIL:EVAL $PKG" | tee -a "$RESULTS"
        rm -rf "$EKAPKGS/pkgs/$PKG"
        continue
    fi

    # Build with timeout
    if ! timeout 660 nix-build -A "$PKG" --no-out-link --timeout 600 >/dev/null 2>&1; then
        echo "FAIL:BUILD $PKG" | tee -a "$RESULTS"
        rm -rf "$EKAPKGS/pkgs/$PKG"
        continue
    fi

    # Get version
    VERSION=$(nix-instantiate --eval -A "$PKG.version" 2>/dev/null | tr -d '"' || echo "unknown")

    # Commit with lock
    if git_commit_with_lock "$PKG" "$VERSION"; then
        echo "OK $PKG $VERSION" | tee -a "$RESULTS"
    else
        echo "FAIL:COMMIT $PKG" | tee -a "$RESULTS"
        git reset HEAD -- "pkgs/$PKG/" 2>/dev/null
        rm -rf "$EKAPKGS/pkgs/$PKG"
    fi
done

echo ""
echo "=== SUMMARY ==="
echo "OK: $(grep -c '^OK' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:EVAL: $(grep -c '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:BUILD: $(grep -c '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo 0)"
echo "FAIL:COMMIT: $(grep -c '^FAIL:COMMIT' "$RESULTS" 2>/dev/null || echo 0)"
echo "SKIP: $(grep -c '^SKIP' "$RESULTS" 2>/dev/null || echo 0)"
