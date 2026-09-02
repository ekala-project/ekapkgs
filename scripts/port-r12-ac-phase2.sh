#!/usr/bin/env bash
# Phase 2: Build and commit all packages that passed eval in phase 1
# Reads /tmp/r12-ac-eval-pass.txt

EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

> /tmp/r12-ac-success.txt
> /tmp/r12-ac-fail-build.txt
> /tmp/r12-ac-fail-timeout.txt
> /tmp/r12-ac-p2-skip.txt

mapfile -t PACKAGES < /tmp/r12-ac-eval-pass.txt
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))

  dest_dir="$EKAPKGS/pkgs/${pkg}"

  # Skip if already committed
  if git -C "$EKAPKGS" log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg" >> /tmp/r12-ac-p2-skip.txt
    continue
  fi

  # Skip if dir doesn't exist (shouldn't happen but just in case)
  if [ ! -d "$dest_dir" ]; then
    echo "[$idx/$total] SKIP(no dir): $pkg"
    echo "$pkg" >> /tmp/r12-ac-p2-skip.txt
    continue
  fi

  # Build
  echo -n "[$idx/$total] Building $pkg... "
  BUILD_OUTPUT=$(timeout 600 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
  BUILD_EXIT=$?

  if [ "$BUILD_EXIT" -eq 124 ]; then
    echo "TIMEOUT"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r12-ac-fail-timeout.txt
    continue
  elif [ "$BUILD_EXIT" -ne 0 ]; then
    echo "FAIL"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r12-ac-fail-build.txt
    continue
  fi

  # Get version and commit
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
  git -C "$EKAPKGS" add "pkgs/${pkg}/" 2>/dev/null
  git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}" 2>/dev/null

  echo "OK ($version)"
  echo "$pkg: $version" >> /tmp/r12-ac-success.txt
done

echo ""
echo "================================================================"
echo "PHASE 2 FINAL RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r12-ac-success.txt)"
cat /tmp/r12-ac-success.txt
echo ""
echo "FAIL_BUILD: $(wc -l < /tmp/r12-ac-fail-build.txt)"
cat /tmp/r12-ac-fail-build.txt
echo ""
echo "FAIL_TIMEOUT: $(wc -l < /tmp/r12-ac-fail-timeout.txt)"
cat /tmp/r12-ac-fail-timeout.txt
echo ""
echo "SKIPPED: $(wc -l < /tmp/r12-ac-p2-skip.txt)"
cat /tmp/r12-ac-p2-skip.txt
