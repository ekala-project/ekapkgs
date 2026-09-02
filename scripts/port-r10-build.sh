#!/usr/bin/env bash
# Build and commit packages from eval-pass list, running builds with 600s timeout
# Tracks results and commits each successful package

EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

> /tmp/r10-build-success.txt
> /tmp/r10-build-fail.txt
> /tmp/r10-build-timeout.txt

mapfile -t PACKAGES < /tmp/r10-eval-pass.txt
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

  if [ ! -d "$dest_dir" ]; then
    echo "[$idx/$total] SKIP(no dir): $pkg"
    continue
  fi

  echo -n "[$idx/$total] Building $pkg... "
  BUILD_OUTPUT=$(timeout 600 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
  BUILD_EXIT=$?

  if [ "$BUILD_EXIT" -eq 124 ]; then
    echo "TIMEOUT"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r10-build-timeout.txt
    continue
  elif [ "$BUILD_EXIT" -ne 0 ]; then
    echo "FAIL"
    echo "$BUILD_OUTPUT" | tail -3
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r10-build-fail.txt
    continue
  fi

  # Get version
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git -C "$EKAPKGS" add "pkgs/${pkg}/" 2>/dev/null
  git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}" 2>/dev/null

  echo "OK ($version)"
  echo "$pkg: $version" >> /tmp/r10-build-success.txt
done

echo ""
echo "================================================================"
echo "BUILD RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r10-build-success.txt)"
echo "FAIL: $(wc -l < /tmp/r10-build-fail.txt)"
echo "TIMEOUT: $(wc -l < /tmp/r10-build-timeout.txt)"
echo ""
echo "=== SUCCESSES ==="
cat /tmp/r10-build-success.txt
echo ""
echo "=== FAILURES ==="
cat /tmp/r10-build-fail.txt
echo ""
echo "=== TIMEOUTS ==="
cat /tmp/r10-build-timeout.txt
