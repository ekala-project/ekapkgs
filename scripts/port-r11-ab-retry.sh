#!/usr/bin/env bash
set -euo pipefail

# Retry packages that were skipped in smart script due to deleted dirs

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

>> /tmp/r11-ab-success.txt
>> /tmp/r11-ab-fail-build.txt

apply_transforms() {
  local nix_file="$1"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$nix_file"
  sed -i '/^\s*nix-update-script,$/d; /^\s*nix-update-script$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater,$/d; /^\s*unstableGitUpdater$/d' "$nix_file"
  sed -i '/^\s*gitUpdater,$/d; /^\s*gitUpdater$/d' "$nix_file"
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
  sed -i '/^\s*nixosTests,$/d; /^\s*nixosTests$/d' "$nix_file"
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*nixosTests\.\w+\s*;\n/\n/gs' "$nix_file"
  sed -i '/^\s*versionCheckHook,$/d; /^\s*versionCheckHook$/d' "$nix_file"
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
}

mapfile -t PACKAGES < /tmp/r11-ab-retry.txt
total=${#PACKAGES[@]}
idx=0

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))
  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"

  # Skip if already committed
  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    continue
  fi

  mkdir -p "$dest_dir"
  cp "$src_dir/package.nix" "$dest_dir/default.nix"
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  apply_transforms "$dest_dir/default.nix"

  # Check if it needs Go 1.26
  if grep -q 'buildGoModule' "$dest_dir/default.nix"; then
    # Speculatively check if it needs go >= 1.26
    drv=$(nix-instantiate -A "$pkg" 2>/dev/null || true)
    if [ -n "$drv" ]; then
      build_out=$(timeout 60 nix-build -A "$pkg" --timeout 60 --no-out-link 2>&1 || true)
      if echo "$build_out" | grep -q "go >= 1.26"; then
        sed -i 's/buildGoModule/buildGo126Module/g' "$dest_dir/default.nix"
        $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true
      fi
    fi
  fi

  # Eval
  if ! nix-instantiate -A "$pkg" 2>/dev/null 1>/dev/null; then
    echo "[$idx/$total] FAIL(eval): $pkg"
    rm -rf "$dest_dir"
    continue
  fi

  # Build
  echo "[$idx/$total] Building $pkg..."
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link 2>&1 | tail -3; then
    $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
    git add "pkgs/${pkg}/"
    git commit -m "${pkg}: init at ${version}"
    echo "[$idx/$total] SUCCESS: $pkg at $version"
    echo "$pkg: $version" >> /tmp/r11-ab-success.txt
  else
    echo "[$idx/$total] FAIL(build): $pkg"
    echo "$pkg" >> /tmp/r11-ab-fail-build.txt
    rm -rf "$dest_dir"
  fi
done

echo ""
echo "=== RETRY COMPLETE ==="
echo "Total successes so far: $(wc -l < /tmp/r11-ab-success.txt)"
cat /tmp/r11-ab-success.txt
