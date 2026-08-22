#!/usr/bin/env bash
# Port r17-batch-ab packages - v3: recreate, eval, dry-run to find buildable, then build
set -uo pipefail
export NIXPKGS_ALLOW_UNFREE=1

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r17-ab-v3-success.txt
> /tmp/r17-ab-v3-eval-fail.txt
> /tmp/r17-ab-v3-build-fail.txt
> /tmp/r17-ab-v3-skip.txt
> /tmp/r17-ab-v3-eval-pass.txt

apply_transforms() {
  local nix_file="$1"

  # Maintainers -> empty list
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

  # Go packages: convert buildGoModule to buildGo126Module
  if grep -q '\bbuildGoModule\b' "$nix_file"; then
    sed -i 's/\bbuildGoModule\b/buildGo126Module/g' "$nix_file"
  fi

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

setup_pkg() {
  local pkg="$1"
  local prefix="${pkg:0:2}"
  local src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  local dest_dir="$EKAPKGS/pkgs/${pkg}"

  rm -rf "$dest_dir"
  mkdir -p "$dest_dir"
  cp "$src_dir/package.nix" "$dest_dir/default.nix"
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  apply_transforms "$dest_dir/default.nix"
  "$NIXFMT" "$dest_dir/default.nix" 2>/dev/null || true
}

# Read packages
mapfile -t PACKAGES < /tmp/r17-batch-ab
total=${#PACKAGES[@]}

echo "=== PHASE 1: Setup and eval all $total packages ==="
idx=0
for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))

  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"

  if [ ! -f "$src_dir/package.nix" ]; then
    echo "[$idx/$total] SKIP(no source): $pkg"
    echo "$pkg (no source)" >> /tmp/r17-ab-v3-skip.txt
    continue
  fi

  # Skip if already committed
  if git log --oneline -1 --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg" >> /tmp/r17-ab-v3-skip.txt
    continue
  fi

  setup_pkg "$pkg"

  if ! nix-instantiate -A "$pkg" 2>/dev/null >/dev/null; then
    echo "[$idx/$total] EVAL_FAIL: $pkg"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r17-ab-v3-eval-fail.txt
    continue
  fi

  echo "[$idx/$total] EVAL_OK: $pkg"
  echo "$pkg" >> /tmp/r17-ab-v3-eval-pass.txt
done

echo ""
echo "=== PHASE 1 DONE: $(wc -l < /tmp/r17-ab-v3-eval-pass.txt) packages pass eval ==="

# PHASE 2: Quick check which ones can build (dry-run to find cache hits)
echo ""
echo "=== PHASE 2: Build packages ==="
bidx=0
btotal=$(wc -l < /tmp/r17-ab-v3-eval-pass.txt)

while IFS= read -r pkg; do
  bidx=$((bidx + 1))
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  nix_file="$dest_dir/default.nix"

  echo -n "[$bidx/$btotal] Building $pkg... "

  # Build with timeout
  build_output=$(timeout 660 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
  build_rc=$?

  if [ $build_rc -ne 0 ]; then
    echo "BUILD_FAIL"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r17-ab-v3-build-fail.txt
    continue
  fi

  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
  "$NIXFMT" "$nix_file" 2>/dev/null || true

  git add "pkgs/${pkg}/"
  if git commit -m "${pkg}: init at ${version}"; then
    echo "OK ($version)"
    echo "$pkg: $version" >> /tmp/r17-ab-v3-success.txt
  else
    echo "COMMIT_FAIL"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r17-ab-v3-build-fail.txt
  fi
done < /tmp/r17-ab-v3-eval-pass.txt

echo ""
echo "================================================================"
echo "FINAL RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r17-ab-v3-success.txt)"
cat /tmp/r17-ab-v3-success.txt
echo ""
echo "EVAL_FAIL: $(wc -l < /tmp/r17-ab-v3-eval-fail.txt)"
cat /tmp/r17-ab-v3-eval-fail.txt
echo ""
echo "BUILD_FAIL: $(wc -l < /tmp/r17-ab-v3-build-fail.txt)"
cat /tmp/r17-ab-v3-build-fail.txt
echo ""
echo "SKIPPED: $(wc -l < /tmp/r17-ab-v3-skip.txt)"
cat /tmp/r17-ab-v3-skip.txt
