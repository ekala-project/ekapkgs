#!/usr/bin/env bash
set -uo pipefail
# NOTE: no -e so we control error handling ourselves

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r12-ab-success.txt
> /tmp/r12-ab-fail-eval.txt
> /tmp/r12-ab-fail-build.txt
> /tmp/r12-ab-skip.txt

apply_transforms() {
  local nix_file="$1"

  # Maintainers transforms
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$nix_file"

  # Remove update-related inputs
  sed -i '/^\s*_experimental-update-script-combinators,$/d' "$nix_file"
  sed -i '/^\s*_experimental-update-script-combinators$/d' "$nix_file"
  sed -i '/^\s*nix-update-script,$/d' "$nix_file"
  sed -i '/^\s*nix-update-script$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,$/d' "$nix_file"
  sed -i '/^\s*gitUpdater$/d' "$nix_file"

  # Remove updateScript assignments (various patterns)
  sed -i '/passthru\.updateScript/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\}\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\)\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*nix-update-script\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*unstableGitUpdater\s*\{[^}]*\}\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*unstableGitUpdater\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*gitUpdater\s*\{[^}]*\}\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*gitUpdater\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*\.\/update\.\w+\s*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*writeScript\s[^;]*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*_experimental-update-script-combinators[^;]*;\n/\n/gs' "$nix_file"
  # Catch-all for remaining updateScript patterns
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*(?:(?!;\n).)*;\n/\n/gs' "$nix_file"

  # Remove nixosTests references
  sed -i '/^\s*nixosTests,$/d' "$nix_file"
  sed -i '/^\s*nixosTests$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*nixosTests\.\w+\s*;\n/\n/gs' "$nix_file"

  # Remove versionCheckHook
  sed -i '/^\s*versionCheckHook,$/d' "$nix_file"
  sed -i '/^\s*versionCheckHook$/d' "$nix_file"
  sed -i '/versionCheckHook/d' "$nix_file"
  if ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck = true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  # Add cmake.configurePhaseHook for cmake packages
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # Add meson.configurePhaseHook for meson packages
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  # Clean up empty blocks
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\];\n/\n/gs' "$nix_file"
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Format
  $NIXFMT "$nix_file" 2>/dev/null || true
}

port_package() {
  local pkg="$1"
  local idx="$2"
  local total="$3"
  local prefix="${pkg:0:2}"
  local src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  local dest_dir="$EKAPKGS/pkgs/${pkg}"
  local src_file="$src_dir/package.nix"

  # Check source exists
  if [ ! -f "$src_file" ]; then
    echo "[$idx/$total] SKIP(no source): $pkg"
    echo "$pkg: source not found" >> /tmp/r12-ab-skip.txt
    return
  fi

  # Check already committed
  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg: already committed" >> /tmp/r12-ab-skip.txt
    return
  fi

  # Copy files
  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_dir/default.nix"
  for f in "$src_dir"/*; do
    local fname
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  # Apply transforms
  apply_transforms "$dest_dir/default.nix"

  # Eval
  if ! nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "[$idx/$total] FAIL(eval): $pkg"
    echo "$pkg" >> /tmp/r12-ab-fail-eval.txt
    rm -rf "$dest_dir"
    return
  fi

  # Build with timeout
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link >/dev/null 2>&1; then
    # Re-run nixfmt to be sure
    $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true
    local version
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
    git -C "$EKAPKGS" add "pkgs/${pkg}/"
    git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"
    echo "[$idx/$total] SUCCESS: $pkg at $version"
    echo "$pkg: $version" >> /tmp/r12-ab-success.txt
  else
    echo "[$idx/$total] FAIL(build): $pkg"
    echo "$pkg" >> /tmp/r12-ab-fail-build.txt
    rm -rf "$dest_dir"
  fi
}

mapfile -t PACKAGES < /tmp/r12-batch-ab
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))
  port_package "$pkg" "$idx" "$total"
done

echo ""
echo "=========================================="
echo "FINAL RESULTS"
echo "=========================================="
echo "SUCCESS: $(wc -l < /tmp/r12-ab-success.txt)"
echo "FAIL EVAL: $(wc -l < /tmp/r12-ab-fail-eval.txt)"
echo "FAIL BUILD: $(wc -l < /tmp/r12-ab-fail-build.txt)"
echo "SKIP: $(wc -l < /tmp/r12-ab-skip.txt)"
echo ""
echo "=== Successes ==="
cat /tmp/r12-ab-success.txt
echo ""
echo "=== Eval Failures ==="
cat /tmp/r12-ab-fail-eval.txt
echo ""
echo "=== Build Failures ==="
cat /tmp/r12-ab-fail-build.txt
