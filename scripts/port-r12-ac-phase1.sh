#!/usr/bin/env bash
# Phase 1: Copy, transform, format, and eval-check all packages from r12-batch-ac
# Produces /tmp/r12-ac-eval-pass.txt and /tmp/r12-ac-eval-fail.txt

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r12-ac-eval-pass.txt
> /tmp/r12-ac-eval-fail.txt
> /tmp/r12-ac-p1-skip.txt
> /tmp/r12-ac-success.txt
> /tmp/r12-ac-fail-build.txt
> /tmp/r12-ac-fail-timeout.txt

mapfile -t PACKAGES < /tmp/r12-batch-ac
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
    echo "$pkg" >> /tmp/r12-ac-p1-skip.txt
    continue
  fi

  # Skip if already committed
  if git -C "$EKAPKGS" log --oneline --all --grep="${pkg}: init" -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg" >> /tmp/r12-ac-p1-skip.txt
    continue
  fi

  # Clean and recreate
  rm -rf "$dest_dir"
  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_dir/default.nix"

  # Copy extras (patches, etc.)
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  nix_file="$dest_dir/default.nix"

  # === TRANSFORMS ===

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

  # Remove updateScript assignments
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

  # Remove empty passthru
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Format
  "$NIXFMT" "$nix_file" 2>/dev/null || true

  # Eval
  if nix-instantiate -A "$pkg" 2>/dev/null >/dev/null; then
    echo "[$idx/$total] EVAL_OK: $pkg"
    echo "$pkg" >> /tmp/r12-ac-eval-pass.txt

    # === BUILD AND COMMIT IMMEDIATELY ===
    echo -n "  Building $pkg... "
    BUILD_OUTPUT=$(timeout 600 nix-build -A "$pkg" --no-out-link --timeout 600 2>&1)
    BUILD_EXIT=$?

    if [ "$BUILD_EXIT" -eq 124 ]; then
      echo "TIMEOUT"
      rm -rf "$dest_dir"
      echo "$pkg" >> /tmp/r12-ac-fail-timeout.txt
    elif [ "$BUILD_EXIT" -ne 0 ]; then
      echo "BUILD_FAIL"
      rm -rf "$dest_dir"
      echo "$pkg" >> /tmp/r12-ac-fail-build.txt
    else
      version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
      git -C "$EKAPKGS" add "pkgs/${pkg}/" 2>/dev/null
      git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}" 2>/dev/null
      echo "OK ($version)"
      echo "$pkg: $version" >> /tmp/r12-ac-success.txt
    fi
  else
    echo "[$idx/$total] EVAL_FAIL: $pkg"
    rm -rf "$dest_dir"
    echo "$pkg" >> /tmp/r12-ac-eval-fail.txt
  fi
done

echo ""
echo "================================================================"
echo "FINAL RESULTS"
echo "================================================================"
echo "SUCCESS: $(cat /tmp/r12-ac-success.txt 2>/dev/null | wc -l)"
cat /tmp/r12-ac-success.txt 2>/dev/null
echo ""
echo "EVAL_FAIL: $(wc -l < /tmp/r12-ac-eval-fail.txt)"
echo "BUILD_FAIL: $(cat /tmp/r12-ac-fail-build.txt 2>/dev/null | wc -l)"
echo "TIMEOUT: $(cat /tmp/r12-ac-fail-timeout.txt 2>/dev/null | wc -l)"
echo "SKIPPED: $(wc -l < /tmp/r12-ac-p1-skip.txt)"
