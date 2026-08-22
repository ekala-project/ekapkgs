#!/usr/bin/env bash
set -euo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

# Read packages from the batch files
mapfile -t PACKAGES < <(cat /tmp/nr-batch-ae /tmp/nr-batch-af /tmp/nr-batch-ag)

SUCCESS=()
FAIL_EVAL=()
FAIL_BUILD=()
FAIL_FMT=()
SKIPPED=()

for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "================================================================"
  echo "Processing: $pkg"
  echo "================================================================"

  # Skip if already exists
  if [ -d "$EKAPKGS/pkgs/$pkg" ]; then
    echo "SKIP: already exists"
    SKIPPED+=("$pkg: already exists")
    continue
  fi

  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "SKIP: source not found at $src_file"
    SKIPPED+=("$pkg: source not found")
    continue
  fi

  # Create destination directory
  mkdir -p "$dest_dir"

  # Copy package.nix as default.nix
  cp "$src_file" "$dest_dir/default.nix"

  # Copy any extra files (patches, etc.) but skip test directories and update scripts
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
  sed -i -E 's/maintainers = with lib\.maintainers; \[[^]]*\]/maintainers = [ ]/g' "$nix_file"
  sed -i -E 's/maintainers = \[ lib\.maintainers\.[^ ]* \]/maintainers = [ ]/g' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[\s*\n([^\]]*?)\s*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*\n\s*(lib\.maintainers\.\w+\s*\n?\s*)*\]/maintainers = [ ]/gs' "$nix_file"

  # Transform 2: Remove nix-update-script from inputs
  sed -i '/^\s*nix-update-script,$/d' "$nix_file"
  sed -i '/^\s*nix-update-script$/d' "$nix_file"
  # Remove unstableGitUpdater from inputs
  sed -i '/^\s*unstableGitUpdater,$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater$/d' "$nix_file"
  # Remove gitUpdater from inputs
  sed -i '/^\s*gitUpdater,$/d' "$nix_file"
  sed -i '/^\s*gitUpdater$/d' "$nix_file"

  # Transform 3: Remove passthru.updateScript (various patterns)
  sed -i '/passthru\.updateScript/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript = nix-update-script \{[^}]*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript = unstableGitUpdater \{[^}]*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript = nix-update-script \{\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript = \.\/update\.sh;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script\s*\(\s*\{[^}]*\}\s*\);\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*nix-update-script;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*unstableGitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater\s*\{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*gitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript\s*=\s*\.\/[^;]*;\n?//gs' "$nix_file"

  # Transform 4: Remove nixosTests refs
  sed -i '/^\s*nixosTests,$/d' "$nix_file"
  sed -i '/^\s*nixosTests$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests = \{ inherit \(nixosTests\) [^;]*; \};\n/\n/gs' "$nix_file"

  # Transform 5: Remove versionCheckHook and related
  sed -i '/^\s*versionCheckHook,$/d' "$nix_file"
  sed -i '/^\s*versionCheckHook$/d' "$nix_file"
  sed -i '/nativeInstallCheckInputs = \[ versionCheckHook \];/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs = \[\s*\n\s*versionCheckHook\s*\n\s*\];\n/\n/gs' "$nix_file"
  if ! grep -q 'versionCheckHook' "$nix_file" && ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck = true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram = /d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg = /d' "$nix_file"
  fi

  # Transform 6: CMake - add cmake.configurePhaseHook to nativeBuildInputs
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      # Use perl to add cmake.configurePhaseHook after cmake in nativeBuildInputs
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # Transform 7: Meson - add meson.configurePhaseHook after meson in nativeBuildInputs
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  # Transform 8: Remove empty passthru blocks
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"

  # Transform 9: Remove tests from inputs if leftover
  # sed -i '/^\s*tests,$/d' "$nix_file"

  # Clean up double blank lines
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Format
  nixfmt "$nix_file" 2>/dev/null || true

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
  set +e
  build_output=$(timeout 300 nix-build -A "$pkg" --timeout 300 --no-out-link 2>&1)
  build_exit=$?
  set -e

  if [ "$build_exit" -ne 0 ]; then
    echo "$build_output" | tail -5
    if [ "$build_exit" -eq 124 ]; then
      echo "TIMEOUT: $pkg"
    else
      echo "FAIL_BUILD: $pkg"
    fi
    rm -rf "$dest_dir"
    FAIL_BUILD+=("$pkg")
    continue
  fi

  # Format after build
  if ! nix fmt "$nix_file" 2>/dev/null; then
    echo "FAIL_FMT: $pkg (but build succeeded, committing anyway)"
    FAIL_FMT+=("$pkg")
  fi

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
echo "FAILED FMT (${#FAIL_FMT[@]}):"
for s in "${FAIL_FMT[@]}"; do echo "  $s"; done
echo ""
echo "SKIPPED (${#SKIPPED[@]}):"
for s in "${SKIPPED[@]}"; do echo "  $s"; done
