#!/usr/bin/env bash
# Port r18-batch-aa packages from nixpkgs to ekapkgs
set -uo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r18-aa-success.txt
> /tmp/r18-aa-eval-fail.txt
> /tmp/r18-aa-build-fail.txt
> /tmp/r18-aa-timeout.txt
> /tmp/r18-aa-skip.txt

apply_transforms() {
  local nix_file="$1"

  # Maintainers -> empty list
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[(?:[^\]]*?lib\.maintainers[^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*\n\s*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.teams\.\w+\.members\s*\+\+\s*)?with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*lib\.teams\.\w+\.members;/maintainers = [ ];/gs' "$nix_file"

  # Remove update scripts from inputs
  sed -i '/^\s*nix-update-script,\?$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,\?$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,\?$/d' "$nix_file"
  sed -i '/passthru\.updateScript/d' "$nix_file"

  # Remove updateScript assignments (multi-line aware)
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\);\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*\.\/update[^;]*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*writeScript\s+[^;]*;\n?//gs' "$nix_file"

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
  if ! grep -q 'versionCheckHook' "$nix_file" && ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck\s*=\s*true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  # Remove testers
  perl -0777 -i -pe 's/\s*tests\.version\s*=\s*testers\.testVersion\s*\{[^}]*\}\s*;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*tests\.version\s*=\s*testers\.testVersion\s*;\n?//gs' "$nix_file"
  sed -i '/^\s*testers,\?$/d' "$nix_file"

  # cmake: add configurePhaseHook (handle CMake >= 4 needing cmake.v4)
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # meson: add configurePhaseHook + ninja
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  # Remove empty passthru
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*tests\s*=\s*\{\s*\};\s*\};\n/\n/gs' "$nix_file"
  sed -i '/^$/N;/^\n$/d' "$nix_file"
}

mapfile -t PACKAGES < /tmp/r18-batch-aa
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))

  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "[$idx/$total] SKIP(no source): $pkg"
    echo "$pkg" >> /tmp/r18-aa-skip.txt
    continue
  fi

  # Skip if already committed
  if git log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg" >> /tmp/r18-aa-skip.txt
    continue
  fi

  # Skip if dir already exists (partial run)
  if [ -d "$dest_dir" ]; then
    echo "[$idx/$total] SKIP(exists): $pkg"
    echo "$pkg" >> /tmp/r18-aa-skip.txt
    continue
  fi

  # Create destination
  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_dir/default.nix"

  # Copy extras (patches, etc.)
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  nix_file="$dest_dir/default.nix"

  # Apply transforms
  apply_transforms "$nix_file"

  # Format
  "$NIXFMT" "$nix_file" 2>/dev/null || true

  # Eval
  if ! nix-instantiate -A "$pkg" 2>/dev/null >/dev/null; then
    echo "[$idx/$total] EVAL_FAIL: $pkg"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r18-aa-eval-fail.txt
    continue
  fi

  # Build
  echo -n "[$idx/$total] Building $pkg... "
  if ! timeout 660 nix-build -A "$pkg" --no-out-link --timeout 600 2>/dev/null >/dev/null; then
    echo "BUILD_FAIL"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r18-aa-build-fail.txt
    continue
  fi

  # Get version
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git add "pkgs/${pkg}/"
  if git diff --cached --quiet "pkgs/${pkg}/" 2>/dev/null; then
    git add "pkgs/${pkg}"
  fi

  if git commit -m "${pkg}: init at ${version}"; then
    echo "OK ($version)"
    echo "$pkg: $version" >> /tmp/r18-aa-success.txt
  else
    echo "COMMIT_FAIL ($version)"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r18-aa-build-fail.txt
  fi
done

echo ""
echo "================================================================"
echo "FINAL RESULTS"
echo "================================================================"
echo "SUCCESS: $(wc -l < /tmp/r18-aa-success.txt)"
cat /tmp/r18-aa-success.txt
echo ""
echo "EVAL_FAIL: $(wc -l < /tmp/r18-aa-eval-fail.txt)"
cat /tmp/r18-aa-eval-fail.txt
echo ""
echo "BUILD_FAIL: $(wc -l < /tmp/r18-aa-build-fail.txt)"
cat /tmp/r18-aa-build-fail.txt
echo ""
echo "TIMEOUT: $(wc -l < /tmp/r18-aa-timeout.txt)"
echo "SKIPPED: $(wc -l < /tmp/r18-aa-skip.txt)"
cat /tmp/r18-aa-skip.txt
