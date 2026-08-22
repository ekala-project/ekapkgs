#!/usr/bin/env bash
# Port packages from nixpkgs to ekapkgs (batches ac-ad)

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

# Read packages from batch files
mapfile -t PACKAGES < <(cat /tmp/nr-batch-ac /tmp/nr-batch-ad)

SUCCESS=()
FAIL_EVAL=()
FAIL_BUILD=()
FAIL_TIMEOUT=()
FAIL_COMMIT=()
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

  # Skip if already exists
  if [ -d "$dest_dir" ]; then
    echo "SKIP: already exists"
    SKIPPED+=("$pkg: already exists")
    continue
  fi

  # Skip if already committed (check git log)
  if git -C "$EKAPKGS" log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "SKIP: already committed"
    SKIPPED+=("$pkg: already committed")
    continue
  fi

  # Clean up any leftover from previous failed attempt
  rm -rf "$dest_dir"

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
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[(?:[^\]]*?lib\.maintainers[^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*\n\s*\]/maintainers = [ ]/gs' "$nix_file"

  # Transform 2: Remove nix-update-script and unstableGitUpdater from inputs
  sed -i '/^\s*nix-update-script,\?$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,\?$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,\?$/d' "$nix_file"

  # Remove passthru.updateScript (single line)
  sed -i '/passthru\.updateScript/d' "$nix_file"

  # Remove updateScript from passthru blocks (multi-line patterns)
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\);\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*\.\/update\.sh;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*\.\/update\.py;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*writeScript\s+[^;]*;\n?//gs' "$nix_file"

  # Transform 3: Remove nixosTests references
  sed -i '/^\s*nixosTests,\?$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  sed -i '/nixosTests\./d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"

  # Transform 4: Remove versionCheckHook
  sed -i '/^\s*versionCheckHook,\?$/d' "$nix_file"
  sed -i '/nativeInstallCheckInputs\s*=\s*\[\s*versionCheckHook\s*\];/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\n\s*versionCheckHook\s*\n\s*\];\n/\n/gs' "$nix_file"
  # Remove doInstallCheck and versionCheckProgram if no more check hooks
  if ! grep -q 'versionCheckHook' "$nix_file" && ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck\s*=\s*true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  # Transform 5: CMake - add cmake.configurePhaseHook
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook\|cmake\.v4\.configurePhaseHook' "$nix_file"; then
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
  # Remove double blank lines
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Validate: nix-instantiate
  echo "  Evaluating $pkg..."
  if ! nix-instantiate -A "$pkg" 2>/dev/null; then
    echo "FAIL_EVAL: $pkg"
    rm -rf "$dest_dir"
    FAIL_EVAL+=("$pkg")
    continue
  fi

  # Validate: nix-build with timeout
  echo "  Building $pkg (timeout 300s)..."
  timeout 300 nix-build -A "$pkg" --no-out-link --timeout 300 2>&1 | tail -5
  BUILD_EXIT=${PIPESTATUS[0]}

  if [ "$BUILD_EXIT" -eq 124 ]; then
    echo "TIMEOUT: $pkg"
    rm -rf "$dest_dir"
    FAIL_TIMEOUT+=("$pkg")
    continue
  elif [ "$BUILD_EXIT" -ne 0 ]; then
    echo "FAIL_BUILD: $pkg"
    rm -rf "$dest_dir"
    FAIL_BUILD+=("$pkg")
    continue
  fi

  # Get version
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  if git -C "$EKAPKGS" add "pkgs/${pkg}/" && git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"; then
    echo "SUCCESS: $pkg at $version"
    SUCCESS+=("$pkg: $version")
  else
    echo "FAIL_COMMIT: $pkg"
    rm -rf "$dest_dir"
    git -C "$EKAPKGS" checkout -- "pkgs/${pkg}/" 2>/dev/null || true
    FAIL_COMMIT+=("$pkg")
  fi
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
echo "FAILED TIMEOUT (${#FAIL_TIMEOUT[@]}):"
for s in "${FAIL_TIMEOUT[@]}"; do echo "  $s"; done
echo ""
echo "FAILED COMMIT (${#FAIL_COMMIT[@]}):"
for s in "${FAIL_COMMIT[@]}"; do echo "  $s"; done
echo ""
echo "SKIPPED (${#SKIPPED[@]}):"
for s in "${SKIPPED[@]}"; do echo "  $s"; done
