#!/usr/bin/env bash
# Port r17-batch-aa packages - v2: fast parallel eval, parallel quick-build probe, then sequential build+commit
set -uo pipefail
export NIXPKGS_ALLOW_UNFREE=1

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r17-aa-v2-success.txt
> /tmp/r17-aa-v2-eval-fail.txt
> /tmp/r17-aa-v2-build-fail.txt
> /tmp/r17-aa-v2-skip.txt
> /tmp/r17-aa-v2-eval-pass.txt

apply_transforms() {
  local nix_file="$1"

  # Maintainers -> empty list (all patterns)
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[(?:[^\]]*?lib\.maintainers[^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*\n\s*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.teams\.\w+\.members\s*\+\+\s*)?with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*lib\.teams\.\w+\.members;/maintainers = [ ];/gs' "$nix_file"

  # Remove updater scripts from inputs
  sed -i '/^\s*nix-update-script,\?$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,\?$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,\?$/d' "$nix_file"
  sed -i '/^\s*directoryListingUpdater,\?$/d' "$nix_file"
  sed -i '/^\s*common-updater-scripts,\?$/d' "$nix_file"
  sed -i '/passthru\.updateScript/d' "$nix_file"

  # Remove updateScript assignments
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\);\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*directoryListingUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*directoryListingUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*\.\/update[^;]*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*writeScript\s+[^;]*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*writeShellScript\s+[^;]*;\n?//gs' "$nix_file"

  # Remove nixosTests refs
  sed -i '/^\s*nixosTests,\?$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  sed -i '/nixosTests\./d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"

  # Remove versionCheckHook
  sed -i '/^\s*versionCheckHook,\?$/d' "$nix_file"
  perl -0777 -i -pe 's/\s*versionCheckHook\n//gs' "$nix_file"
  sed -i '/nativeInstallCheckInputs\s*=\s*\[\s*versionCheckHook\s*\];/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\n\s*versionCheckHook\s*\n\s*\];\n/\n/gs' "$nix_file"
  if ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck\s*=\s*true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  # Remove testers
  perl -0777 -i -pe 's/\s*tests\.version\s*=\s*testers\.testVersion\s*\{[^}]*\}\s*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\.version\s*=\s*testers\.testVersion\s*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\.pkg-config\s*=\s*testers\.testMetaPkgConfig\s+[^;]*;\s*\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\.pkg-config\s*=\s*testers\.testMetaPkgConfig\s*\{[^}]*\}\s*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\s*=\s*\{\s*pkg-config\s*=\s*testers\.testMetaPkgConfig\s+[^;]*;\s*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\.testers\s*=[^;]*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\s*=\s*\{[^}]*testers\.[^}]*\};\n?//gs' "$nix_file"
  sed -i '/^\s*testers,\?$/d' "$nix_file"

  # cmake: add configurePhaseHook
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # meson: add configurePhaseHook
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  # Remove empty passthru blocks
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*tests\s*=\s*\{\s*\};\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\n\s*\};\n/\n/gs' "$nix_file"

  # Remove consecutive blank lines
  sed -i '/^$/N;/^\n$/d' "$nix_file"
}

# Re-apply transforms to the re-created packages from build-fail list
echo "=== Re-applying transforms to re-created packages ==="
while IFS= read -r pkg; do
  nix_file="$EKAPKGS/pkgs/$pkg/default.nix"
  if [ -f "$nix_file" ]; then
    apply_transforms "$nix_file"
    "$NIXFMT" "$nix_file" 2>/dev/null || true
  fi
done < /tmp/r17-aa-build-fail.txt

# Read ALL eval-pass packages (both re-created ones and ones that were still there)
mapfile -t ALL_PKGS < /tmp/r17-aa-eval-pass.txt
total=${#ALL_PKGS[@]}

echo "=== Testing $total packages with quick dry-run builds ==="

# Quick-probe: try nix-build with --dry-run to see if they need building or are cached
# Then for packages that need building, use short timeout
> /tmp/r17-aa-v2-buildable.txt

idx=0
for pkg in "${ALL_PKGS[@]}"; do
  idx=$((idx + 1))
  dest_dir="$EKAPKGS/pkgs/${pkg}"

  if [ ! -d "$dest_dir" ]; then
    echo "[$idx/$total] SKIP(no dir): $pkg"
    continue
  fi

  # Skip if already committed
  if git log --oneline -1 --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    continue
  fi

  echo -n "[$idx/$total] Building $pkg... "

  # Try building with 600s timeout
  if timeout 660 nix-build -A "$pkg" --no-out-link --timeout 600 2>/dev/null >/dev/null; then
    # Get version
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

    # Format
    nix_file="$dest_dir/default.nix"
    "$NIXFMT" "$nix_file" 2>/dev/null || true

    # Commit
    git add "pkgs/${pkg}/"
    if git commit -m "${pkg}: init at ${version}"; then
      echo "OK ($version)"
      echo "$pkg: $version" >> /tmp/r17-aa-v2-success.txt
    else
      echo "COMMIT_FAIL ($version)"
      rm -rf "$dest_dir"
      echo "$pkg" >> /tmp/r17-aa-v2-build-fail.txt
    fi
  else
    echo "BUILD_FAIL"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r17-aa-v2-build-fail.txt
  fi
done

echo ""
echo "================================================================"
echo "FINAL RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r17-aa-v2-success.txt)"
cat /tmp/r17-aa-v2-success.txt
echo ""
echo "BUILD_FAIL: $(wc -l < /tmp/r17-aa-v2-build-fail.txt)"
cat /tmp/r17-aa-v2-build-fail.txt
echo ""
echo "EVAL_FAIL (from phase 1): $(wc -l < /tmp/r17-aa-eval-fail.txt)"
cat /tmp/r17-aa-eval-fail.txt
