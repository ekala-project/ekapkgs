#!/usr/bin/env bash
set -euo pipefail

# Phase 2: Build and commit all packages that passed eval in phase 1

EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r11-ab-success.txt
> /tmp/r11-ab-fail-build.txt

mapfile -t PACKAGES < /tmp/r11-ab-eval-pass.txt
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))

  dest_dir="$EKAPKGS/pkgs/${pkg}"

  # Skip if already committed
  if git -C "$EKAPKGS" log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    continue
  fi

  # Skip if dir doesn't exist
  if [ ! -d "$dest_dir" ]; then
    echo "[$idx/$total] SKIP(no dir): $pkg"
    continue
  fi

  echo "[$idx/$total] Building $pkg..."
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link 2>&1 | tail -3; then
    # Re-format
    $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true

    # Get version
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

    # Commit
    git -C "$EKAPKGS" add "pkgs/${pkg}/"
    git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"

    echo "[$idx/$total] SUCCESS: $pkg at $version"
    echo "$pkg: $version" >> /tmp/r11-ab-success.txt
  else
    echo "[$idx/$total] FAIL(build): $pkg"
    echo "$pkg" >> /tmp/r11-ab-fail-build.txt
    rm -rf "$dest_dir"
  fi
done

echo ""
echo "PHASE 2 COMPLETE"
echo "SUCCESS: $(wc -l < /tmp/r11-ab-success.txt)"
echo "FAIL BUILD: $(wc -l < /tmp/r11-ab-fail-build.txt)"
echo ""
echo "=== Successful packages ==="
cat /tmp/r11-ab-success.txt
