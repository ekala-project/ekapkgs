#!/usr/bin/env bash
# Phase 2: Build packages that passed eval, commit successes
# Reads from /tmp/port-eval-pass.txt

EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
PASS_FILE="/tmp/port-eval-pass.txt"

> /tmp/port-build-results.txt

declare -i success_count=0
declare -i fail_count=0

cd "$EKAPKGS"

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue

  # Skip if already committed
  if git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    echo "SKIP_COMMITTED $pkg" >> /tmp/port-build-results.txt
    continue
  fi

  # Check dir exists (should from phase 1)
  if [ ! -f "pkgs/$pkg/default.nix" ]; then
    echo "SKIP_NODIR $pkg" >> /tmp/port-build-results.txt
    continue
  fi

  # Build
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link > /tmp/port-build-current.log 2>&1; then
    # Extract version
    version=$(grep -oP 'version\s*=\s*"\K[^"]*' "pkgs/$pkg/default.nix" | head -1)
    [ -z "$version" ] && version="unknown"

    git add "pkgs/$pkg/"
    git commit -m "$pkg: init at $version"

    echo "SUCCESS $pkg $version" >> /tmp/port-build-results.txt
    success_count+=1
    echo "SUCCESS $pkg $version"
  else
    echo "FAIL_BUILD $pkg" >> /tmp/port-build-results.txt
    rm -rf "pkgs/$pkg"
    fail_count+=1
    echo "FAIL_BUILD $pkg"
  fi
done < "$PASS_FILE"

echo ""
echo "=== Phase 2 Complete ==="
echo "Build success: $success_count"
echo "Build fail: $fail_count"
