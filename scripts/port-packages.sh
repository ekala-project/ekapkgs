#!/usr/bin/env bash
# Port packages from nixpkgs to ekapkgs
# Usage: bash scripts/port-packages.sh [batch-file]

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH_FILE="${1:-/tmp/r12-batch-aa}"
LOGFILE="/tmp/port-packages.log"
RESULTS_FILE="/tmp/port-results.txt"

> "$LOGFILE"
> "$RESULTS_FILE"

declare -i success_count=0
declare -i skip_count=0
declare -i fail_eval_count=0
declare -i fail_build_count=0
declare -i fail_other_count=0

transform_file() {
  local dest="$1"

  # Remove nix-update-script from inputs
  sed -i '/^[[:space:]]*nix-update-script\s*,\?\s*$/d' "$dest"

  # Remove gitUpdater from inputs
  sed -i '/^[[:space:]]*gitUpdater\s*,\?\s*$/d' "$dest"

  # Remove versionCheckHook from inputs and nativeBuildInputs/nativeInstallCheckInputs
  sed -i '/^[[:space:]]*versionCheckHook\s*,\?\s*$/d' "$dest"

  # Remove nixosTests from inputs
  sed -i '/^[[:space:]]*nixosTests\s*,\?\s*$/d' "$dest"

  # Remove passthru.updateScript single-line forms
  sed -i '/^\s*passthru\.updateScript\s*=/d' "$dest"

  # Remove updateScript inside passthru blocks
  sed -i '/^\s*updateScript\s*=/d' "$dest"

  # Remove multi-line passthru.updateScript = { ... };
  perl -0777 -i -pe 's/\s*passthru\.updateScript\s*=\s*\{[^}]*\}\s*;\s*\n?//gs' "$dest"

  # Remove nixosTests references in passthru.tests
  sed -i '/nixosTests\./d' "$dest"

  # Set meta.maintainers = [ ]
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*)\]/maintainers = [ ]/gs' "$dest"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(?:lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$dest"

  # Add cmake.configurePhaseHook for CMake packages
  if grep -Pq '^\s+cmake\s*$' "$dest" 2>/dev/null; then
    if ! grep -q 'cmake\.configurePhaseHook' "$dest"; then
      sed -i '/^\s\+cmake\s*$/a\    cmake.configurePhaseHook' "$dest"
    fi
  fi

  # Add meson.configurePhaseHook for Meson packages
  if grep -Pq '^\s+meson\s*$' "$dest" 2>/dev/null; then
    if ! grep -q 'meson\.configurePhaseHook' "$dest"; then
      sed -i '/^\s\+meson\s*$/a\    meson.configurePhaseHook' "$dest"
    fi
  fi

  # Clean up multiple consecutive blank lines
  sed -i '/^$/N;/^\n$/d' "$dest"
}

cd "$EKAPKGS"

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue

  # Skip if already committed
  if git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    echo "SKIP $pkg: already committed" >> "$RESULTS_FILE"
    skip_count+=1
    continue
  fi

  # Clean up leftover dir from previous attempt
  [ -d "pkgs/$pkg" ] && rm -rf "pkgs/$pkg"

  # Determine source path
  first_two="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/$first_two/$pkg"
  src_file="$src_dir/package.nix"
  dest_dir="$EKAPKGS/pkgs/$pkg"
  dest_file="$dest_dir/default.nix"

  if [ ! -f "$src_file" ]; then
    echo "SKIP $pkg: source not found" >> "$RESULTS_FILE"
    skip_count+=1
    continue
  fi

  # Copy package
  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_file"

  # Copy extra files (patches, etc.)
  for f in "$src_dir"/*; do
    fname="$(basename "$f")"
    [ "$fname" = "package.nix" ] && continue
    if [ -d "$f" ]; then
      cp -r "$f" "$dest_dir/"
    elif [ -f "$f" ]; then
      cp "$f" "$dest_dir/$fname"
    fi
  done

  # Apply transforms
  transform_file "$dest_file"

  # Format
  if ! "$NIXFMT" "$dest_file" >> "$LOGFILE" 2>&1; then
    echo "FAIL_FMT $pkg" >> "$RESULTS_FILE"
    rm -rf "$dest_dir"
    fail_other_count+=1
    continue
  fi

  # Eval
  if ! nix-instantiate -A "$pkg" >> "$LOGFILE" 2>&1; then
    echo "FAIL_EVAL $pkg" >> "$RESULTS_FILE"
    rm -rf "$dest_dir"
    fail_eval_count+=1
    continue
  fi

  # Build
  if ! timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link >> "$LOGFILE" 2>&1; then
    echo "FAIL_BUILD $pkg" >> "$RESULTS_FILE"
    rm -rf "$dest_dir"
    fail_build_count+=1
    continue
  fi

  # Extract version
  version=$(grep -oP 'version\s*=\s*"\K[^"]*' "$dest_file" | head -1)
  [ -z "$version" ] && version="unknown"

  # Commit
  git add "pkgs/$pkg/"
  git commit -m "$pkg: init at $version"

  echo "SUCCESS $pkg $version" >> "$RESULTS_FILE"
  success_count+=1

done < "$BATCH_FILE"

cat >> "$RESULTS_FILE" <<EOF

=== SUMMARY ===
Success: $success_count
Skip: $skip_count
Fail eval: $fail_eval_count
Fail build: $fail_build_count
Fail other: $fail_other_count
Total: $((success_count + skip_count + fail_eval_count + fail_build_count + fail_other_count))
EOF

echo "Done. Results in $RESULTS_FILE"
