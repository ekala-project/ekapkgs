#!/usr/bin/env bash
set -euo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

mapfile -t PACKAGES < /tmp/r11-batch-ab

SUCCESS=()
FAIL_EVAL=()
FAIL_BUILD=()
SKIPPED=()

for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "================================================================"
  echo "Processing: $pkg"
  echo "================================================================"

  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "SKIP: source not found at $src_file"
    SKIPPED+=("$pkg: source not found")
    continue
  fi

  # Skip if already committed
  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" | grep -q .; then
    echo "SKIP: already committed"
    SKIPPED+=("$pkg: already committed")
    continue
  fi

  # Create destination directory
  mkdir -p "$dest_dir"

  # Copy package.nix as default.nix
  cp "$src_file" "$dest_dir/default.nix"

  # Copy any extra files (patches, etc.)
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    if [ "$fname" = "package.nix" ]; then
      continue
    fi
    cp -r "$f" "$dest_dir/"
  done

  # Apply transforms to default.nix
  nix_file="$dest_dir/default.nix"

  # Transform 1: Set meta.maintainers = [ ]
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  # Handle teams
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$nix_file"

  # Transform 2: Remove passthru.updateScript
  sed -i '/^\s*nix-update-script,$/d' "$nix_file"
  sed -i '/^\s*nix-update-script$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,$/d' "$nix_file"
  sed -i '/^\s*gitUpdater$/d' "$nix_file"
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

  # Transform 3: Remove nixosTests references
  sed -i '/^\s*nixosTests,$/d' "$nix_file"
  sed -i '/^\s*nixosTests$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*nixosTests\.\w+\s*;\n/\n/gs' "$nix_file"

  # Transform 4: Remove versionCheckHook
  sed -i '/^\s*versionCheckHook,$/d' "$nix_file"
  sed -i '/^\s*versionCheckHook$/d' "$nix_file"
  sed -i '/versionCheckHook/d' "$nix_file"
  if ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck = true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  # Transform 5: CMake - add cmake.configurePhaseHook
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # Transform 6: Meson - add meson.configurePhaseHook
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  # Clean up empty passthru blocks
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"

  # Remove empty nativeInstallCheckInputs
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\];\n/\n/gs' "$nix_file"

  # Clean up double blank lines
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Format the file
  $NIXFMT "$nix_file" 2>/dev/null || true

  # Validate: nix-instantiate
  echo "  Evaluating $pkg..."
  if ! nix-instantiate -A "$pkg" 2>/tmp/eval-err-$pkg; then
    echo "FAIL: nix-instantiate failed for $pkg"
    cat /tmp/eval-err-$pkg | tail -5
    rm -rf "$dest_dir"
    FAIL_EVAL+=("$pkg")
    continue
  fi

  # Validate: nix-build with timeout
  echo "  Building $pkg (timeout 600s)..."
  if ! timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link 2>&1 | tail -5; then
    echo "FAIL: nix-build failed or timed out for $pkg"
    rm -rf "$dest_dir"
    FAIL_BUILD+=("$pkg")
    continue
  fi

  # Re-format after successful build
  $NIXFMT "$nix_file" 2>/dev/null || true

  # Determine version for commit message
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git -C "$EKAPKGS" add "pkgs/${pkg}/"
  git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"

  echo "SUCCESS: $pkg at $version"
  SUCCESS+=("$pkg: $version")
done

echo ""
echo "================================================================"
echo "FINAL RESULTS"
echo "================================================================"
echo ""
echo "SUCCESS (${#SUCCESS[@]}):"
for s in "${SUCCESS[@]}"; do echo "  $s"; done
echo ""
echo "FAILED EVAL (${#FAIL_EVAL[@]}):"
for s in "${FAIL_EVAL[@]}"; do echo "  $s"; done
echo ""
echo "FAILED BUILD (${#FAIL_BUILD[@]}):"
for s in "${FAIL_BUILD[@]}"; do echo "  $s"; done
echo ""
echo "SKIPPED (${#SKIPPED[@]}):"
for s in "${SKIPPED[@]}"; do echo "  $s"; done
