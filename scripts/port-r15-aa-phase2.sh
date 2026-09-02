#!/usr/bin/env bash
# Phase 2: Build and commit packages that passed eval
# Reads from /tmp/r15-aa-eval-pass.txt
set -uo pipefail

EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r15-aa-p2-success.txt
> /tmp/r15-aa-p2-build-fail.txt
> /tmp/r15-aa-p2-timeout.txt

mapfile -t PACKAGES < /tmp/r15-aa-eval-pass.txt
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))

  dest_dir="$EKAPKGS/pkgs/${pkg}"
  nix_file="$dest_dir/default.nix"

  if [ ! -f "$nix_file" ]; then
    echo "[$idx/$total] SKIP(no file): $pkg"
    continue
  fi

  # Skip if already committed (in case of reruns)
  if git log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    continue
  fi

  # Build
  echo -n "[$idx/$total] Building $pkg... "
  build_output=$(timeout 660 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
  build_exit=$?

  if [ $build_exit -ne 0 ]; then
    if echo "$build_output" | grep -q "timed out"; then
      echo "TIMEOUT"
      rm -rf "$dest_dir"
      echo "$pkg" >> /tmp/r15-aa-p2-timeout.txt
    else
      echo "BUILD_FAIL"
      rm -rf "$dest_dir"
      echo "$pkg" >> /tmp/r15-aa-p2-build-fail.txt
    fi
    continue
  fi

  # Get version
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git add "pkgs/${pkg}/"
  if git diff --cached --quiet 2>/dev/null; then
    git add "pkgs/${pkg}"
  fi

  if git commit -m "${pkg}: init at ${version}"; then
    echo "OK ($version)"
    echo "$pkg: $version" >> /tmp/r15-aa-p2-success.txt
  else
    echo "COMMIT_FAIL ($version)"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r15-aa-p2-build-fail.txt
  fi
done

echo ""
echo "================================================================"
echo "PHASE 2 RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r15-aa-p2-success.txt)"
cat /tmp/r15-aa-p2-success.txt
echo ""
echo "BUILD_FAIL: $(wc -l < /tmp/r15-aa-p2-build-fail.txt)"
cat /tmp/r15-aa-p2-build-fail.txt
echo ""
echo "TIMEOUT: $(wc -l < /tmp/r15-aa-p2-timeout.txt)"
