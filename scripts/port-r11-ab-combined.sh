#!/usr/bin/env bash
set -euo pipefail

# Combined: Transform, eval, build, and commit all packages in one pass

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r11-ab-success.txt
> /tmp/r11-ab-fail-eval.txt
> /tmp/r11-ab-fail-build.txt
> /tmp/r11-ab-skip.txt

mapfile -t PACKAGES < /tmp/r11-batch-ab
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
    echo "$pkg: source not found" >> /tmp/r11-ab-skip.txt
    continue
  fi

  # Skip if already committed
  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg: already committed" >> /tmp/r11-ab-skip.txt
    continue
  fi

  # Create destination directory
  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_dir/default.nix"

  # Copy any extra files (patches, etc.)
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  nix_file="$dest_dir/default.nix"

  # --- Apply transforms ---
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$nix_file"

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

  sed -i '/^\s*nixosTests,$/d' "$nix_file"
  sed -i '/^\s*nixosTests$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*nixosTests\.\w+\s*;\n/\n/gs' "$nix_file"

  sed -i '/^\s*versionCheckHook,$/d' "$nix_file"
  sed -i '/^\s*versionCheckHook$/d' "$nix_file"
  sed -i '/versionCheckHook/d' "$nix_file"
  if ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck = true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram\s*=/d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg\s*=/d' "$nix_file"
  fi

  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
  fi

  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\];\n/\n/gs' "$nix_file"
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  $NIXFMT "$nix_file" 2>/dev/null || true

  # Eval
  if ! nix-instantiate -A "$pkg" 2>/tmp/r11-ab-eval-err-$pkg 1>/dev/null; then
    echo "[$idx/$total] FAIL(eval): $pkg"
    echo "$pkg" >> /tmp/r11-ab-fail-eval.txt
    rm -rf "$dest_dir"
    continue
  fi

  # Build
  echo "[$idx/$total] Building $pkg..."
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link 2>&1 | tail -3; then
    $NIXFMT "$nix_file" 2>/dev/null || true
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
    git -C "$EKAPKGS" add "pkgs/${pkg}/"
    git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"
    echo "[$idx/$total] SUCCESS: $pkg at $version"
    echo "$pkg: $version" >> /tmp/r11-ab-success.txt
  else
    echo "[$idx/$total] FAIL(build): $pkg"
    echo "$pkg" >> /tmp/r11-ab-fail-build.txt
    rm -rf "$dest_dir"
  fi
done

echo ""
echo "=========================================="
echo "FINAL RESULTS"
echo "=========================================="
echo "SUCCESS: $(wc -l < /tmp/r11-ab-success.txt)"
echo "FAIL EVAL: $(wc -l < /tmp/r11-ab-fail-eval.txt)"
echo "FAIL BUILD: $(wc -l < /tmp/r11-ab-fail-build.txt)"
echo "SKIP: $(wc -l < /tmp/r11-ab-skip.txt)"
echo ""
echo "=== Successes ==="
cat /tmp/r11-ab-success.txt
