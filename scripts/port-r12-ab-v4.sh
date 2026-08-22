#!/usr/bin/env bash
set -uo pipefail

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

  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$nix_file"

  sed -i '/^\s*_experimental-update-script-combinators,$/d' "$nix_file"
  sed -i '/^\s*_experimental-update-script-combinators$/d' "$nix_file"
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
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*_experimental-update-script-combinators[^;]*;\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*(?:(?!;\n).)*;\n/\n/gs' "$nix_file"

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
}

echo "=== PHASE 1: Copy + Transform + Eval ==="
mapfile -t PACKAGES < /tmp/r12-batch-ab
total=${#PACKAGES[@]}
idx=0

> /tmp/r12-ab-eval-pass.txt

for pkg in "${PACKAGES[@]}"; do
  idx=$((idx + 1))
  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "[$idx/$total] SKIP(no source): $pkg"
    echo "$pkg: source not found" >> /tmp/r12-ab-skip.txt
    continue
  fi

  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$idx/$total] SKIP(committed): $pkg"
    echo "$pkg: already committed" >> /tmp/r12-ab-skip.txt
    continue
  fi

  mkdir -p "$dest_dir"
  cp "$src_file" "$dest_dir/default.nix"
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    [ "$fname" = "package.nix" ] && continue
    cp -r "$f" "$dest_dir/"
  done

  apply_transforms "$dest_dir/default.nix"

  if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "[$idx/$total] EVAL OK: $pkg"
    echo "$pkg" >> /tmp/r12-ab-eval-pass.txt
  else
    echo "[$idx/$total] FAIL(eval): $pkg"
    echo "$pkg" >> /tmp/r12-ab-fail-eval.txt
    rm -rf "$dest_dir"
  fi
done

echo ""
echo "=== PHASE 1 COMPLETE ==="
eval_count=$(wc -l < /tmp/r12-ab-eval-pass.txt)
echo "Eval pass: $eval_count"
echo "Eval fail: $(wc -l < /tmp/r12-ab-fail-eval.txt)"
echo ""

echo "=== PHASE 2: Build ==="
bidx=0
while read -r pkg; do
  bidx=$((bidx + 1))
  dest_dir="$EKAPKGS/pkgs/${pkg}"

  if git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    echo "[$bidx/$eval_count] SKIP(committed): $pkg"
    continue
  fi

  if [ ! -d "$dest_dir" ]; then
    echo "[$bidx/$eval_count] SKIP(no dir): $pkg"
    echo "$pkg" >> /tmp/r12-ab-fail-build.txt
    continue
  fi

  echo -n "[$bidx/$eval_count] Building $pkg... "
  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link > /tmp/r12-build-log-$pkg.txt 2>&1; then
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
    $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true
    git -C "$EKAPKGS" add "pkgs/${pkg}/"
    git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"
    echo "SUCCESS at $version"
    echo "$pkg: $version" >> /tmp/r12-ab-success.txt
  else
    echo "FAIL"
    echo "$pkg" >> /tmp/r12-ab-fail-build.txt
    rm -rf "$dest_dir"
  fi
  rm -f /tmp/r12-build-log-$pkg.txt
done < /tmp/r12-ab-eval-pass.txt

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
echo "=== Build Failures ==="
cat /tmp/r12-ab-fail-build.txt
