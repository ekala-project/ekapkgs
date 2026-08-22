#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
RESULTS="/tmp/r15-ab-results-v2.log"
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

    # Apply Python transform
    python3 "$EKAPKGS/scripts/transform-pkg.py" "$NF" 2>/dev/null

    # Format
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
echo "SKIP: $(grep -c '^SKIP' "$RESULTS" 2>/dev/null || echo 0)"
echo ""
echo "=== SUCCESSFUL ==="
grep '^OK' "$RESULTS" 2>/dev/null || echo "(none)"
echo ""
echo "=== EVAL FAILURES ==="
grep '^FAIL:EVAL' "$RESULTS" 2>/dev/null || echo "(none)"
echo ""
echo "=== BUILD FAILURES ==="
grep '^FAIL:BUILD' "$RESULTS" 2>/dev/null || echo "(none)"
