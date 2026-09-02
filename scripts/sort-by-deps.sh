#!/usr/bin/env bash
# Sort eval-passing packages by number of derivations to build (fewest first)
cd /home/jon/projects/ekapkgs

while read -r pkg; do
  [ -d "pkgs/$pkg" ] || continue
  count=$(nix-build -A "$pkg" --no-out-link --dry-run 2>&1 | grep -c '\.drv$' 2>/dev/null || echo 999)
  echo "$count $pkg"
done < /tmp/r10-eval-pass.txt | sort -n > /tmp/r10-sorted-deps.txt

echo "Done. Results in /tmp/r10-sorted-deps.txt"
head -30 /tmp/r10-sorted-deps.txt
