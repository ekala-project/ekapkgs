#!/usr/bin/env bash
# Phase 2: Build and commit packages that passed eval
# Usage: port-r10-phase2.sh [start_line] [end_line]
# Reads from /tmp/r10-eval-pass.txt

EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

START=${1:-1}
END=${2:-999}

mapfile -t PACKAGES < /tmp/r10-eval-pass.txt

SUCCESS=()
FAIL_BUILD=()
FAIL_TIMEOUT=()

total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))
  if [ "$idx" -lt "$START" ] || [ "$idx" -gt "$END" ]; then
    continue
  fi

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

  echo "[$idx/$total] Building $pkg..."
  BUILD_OUTPUT=$(timeout 600 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
  BUILD_EXIT=$?

  if [ "$BUILD_EXIT" -eq 124 ]; then
    echo "[$idx/$total] TIMEOUT: $pkg"
    rm -rf "$dest_dir"
    FAIL_TIMEOUT+=("$pkg")
    continue
  elif [ "$BUILD_EXIT" -ne 0 ]; then
    echo "[$idx/$total] FAIL_BUILD: $pkg"
    echo "$BUILD_OUTPUT" | tail -3
    rm -rf "$dest_dir"
    FAIL_BUILD+=("$pkg")
    continue
  fi

  # Get version
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git -C "$EKAPKGS" add "pkgs/${pkg}/"
  git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"

  echo "[$idx/$total] SUCCESS: $pkg at $version"
  SUCCESS+=("$pkg: $version")
done

echo ""
echo "================================================================"
echo "BATCH RESULTS ($START-$END)"
echo "================================================================"
echo "SUCCESS (${#SUCCESS[@]}):"
for s in "${SUCCESS[@]}"; do echo "  $s"; done
echo ""
echo "FAILED BUILD (${#FAIL_BUILD[@]}):"
for s in "${FAIL_BUILD[@]}"; do echo "  $s"; done
echo ""
echo "FAILED TIMEOUT (${#FAIL_TIMEOUT[@]}):"
for s in "${FAIL_TIMEOUT[@]}"; do echo "  $s"; done
