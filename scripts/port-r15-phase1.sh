#!/usr/bin/env bash
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
EVAL_OK="/tmp/r15-ab-eval-ok.txt"
EVAL_FAIL="/tmp/r15-ab-eval-fail.txt"
EVAL_SKIP="/tmp/r15-ab-eval-skip.txt"
: > "$EVAL_OK"
: > "$EVAL_FAIL"
: > "$EVAL_SKIP"

cd "$EKAPKGS"

while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue

    # Skip if already committed
    if git log --oneline -1 -- "pkgs/$pkg/default.nix" 2>/dev/null | grep -q "init at"; then
        echo "SKIP:COMMITTED $pkg" >> "$EVAL_SKIP"
        continue
    fi

    # Skip if already exists
    if [ -d "$EKAPKGS/pkgs/$pkg" ]; then
        echo "SKIP:EXISTS $pkg" >> "$EVAL_SKIP"
        continue
    fi

    prefix="${pkg:0:2}"
    src_dir="$NIXPKGS/pkgs/by-name/$prefix/$pkg"
    [ ! -f "$src_dir/package.nix" ] && { echo "SKIP:NOSRC $pkg" >> "$EVAL_SKIP"; continue; }

    # Copy
    mkdir -p "$EKAPKGS/pkgs/$pkg"
    cp "$src_dir/package.nix" "$EKAPKGS/pkgs/$pkg/default.nix"
    for f in "$src_dir"/*; do
        base="$(basename "$f")"
        [ "$base" != "package.nix" ] && cp -r "$f" "$EKAPKGS/pkgs/$pkg/$base"
    done

    # Transform
    python3 "$EKAPKGS/scripts/transform-pkg.py" "$EKAPKGS/pkgs/$pkg/default.nix" 2>/dev/null
    $NIXFMT "$EKAPKGS/pkgs/$pkg/default.nix" 2>/dev/null || true

    # Eval
    if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
        echo "$pkg" >> "$EVAL_OK"
        echo "EVAL OK: $pkg"
    else
        echo "$pkg" >> "$EVAL_FAIL"
        echo "EVAL FAIL: $pkg"
        rm -rf "$EKAPKGS/pkgs/$pkg"
    fi
done < /tmp/r15-batch-ab

echo ""
echo "=== PHASE 1 COMPLETE ==="
echo "Eval OK: $(wc -l < "$EVAL_OK")"
echo "Eval Fail: $(wc -l < "$EVAL_FAIL")"
echo "Skipped: $(wc -l < "$EVAL_SKIP")"
