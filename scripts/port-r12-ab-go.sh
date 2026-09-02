#!/usr/bin/env bash
# Port r12-batch-ab: setup, eval, bulk build, commit
# This script is designed to be run once and left running

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
NIXFMT="/nix/store/sgijssgx5ylh2vhajwp98f9sbhsdwhjy-nixfmt-1.3.1/bin/nixfmt"
cd "$EKAPKGS"

> /tmp/r12go-success.txt
> /tmp/r12go-fail-eval.txt
> /tmp/r12go-fail-build.txt

apply_tx() {
  local f="$1"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+maintainers\s*;\s*\[([^\]]*?)\]/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?\s*\+\+\s*(?:lib\.)?teams\.\w+\.members/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:lib\.)?teams\.\w+\.members\s*\+\+\s*\(?\s*with\s+lib\.maintainers\s*;\s*\[[^\]]*\]\s*\)?/maintainers = [ ]/gs' "$f"
  sed -i '/^\s*_experimental-update-script-combinators,$/d;/^\s*_experimental-update-script-combinators$/d' "$f"
  sed -i '/^\s*nix-update-script,$/d;/^\s*nix-update-script$/d' "$f"
  sed -i '/^\s*unstableGitUpdater,$/d;/^\s*unstableGitUpdater$/d' "$f"
  sed -i '/^\s*gitUpdater,$/d;/^\s*gitUpdater$/d' "$f"
  sed -i '/passthru\.updateScript/d' "$f"
  perl -0777 -i -pe 's/\n\s*updateScript\s*=\s*(?:(?!;\n).)*;\n/\n/gs' "$f"
  sed -i '/^\s*nixosTests,$/d;/^\s*nixosTests$/d;/inherit (nixosTests)/d' "$f"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+\(nixosTests\)\s+[^;]*;\s*\};\n/\n/gs' "$f"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*nixosTests\.\w+\s*;\n/\n/gs' "$f"
  sed -i '/^\s*versionCheckHook,$/d;/^\s*versionCheckHook$/d;/versionCheckHook/d' "$f"
  if ! grep -q 'nativeInstallCheckInputs' "$f"; then
    sed -i '/^\s*doInstallCheck = true;$/d;/^\s*versionCheckProgram\s*=/d;/^\s*versionCheckProgramArg\s*=/d' "$f"
  fi
  if grep -q '\bcmake\b' "$f" && ! grep -q 'cmake\.configurePhaseHook' "$f" && ! grep -q 'dontUseCmakeConfigure' "$f"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$f"
  fi
  if grep -q '\bmeson\b' "$f" && ! grep -q 'meson\.configurePhaseHook' "$f"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$f"
  fi
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$f"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs\s*=\s*\[\s*\];\n/\n/gs' "$f"
  sed -i '/^$/N;/^\n$/d' "$f"
  $NIXFMT "$f" 2>/dev/null || true
}

# PHASE 1: Setup + eval
echo "=== PHASE 1: Setup + Eval ==="
> /tmp/r12go-eval-pass.txt
total=$(wc -l < /tmp/r12-batch-ab)
idx=0
while read pkg; do
  idx=$((idx + 1))
  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="pkgs/${pkg}"
  if [ -d "$dest_dir" ] && git log --oneline --all -- "pkgs/${pkg}/" 2>/dev/null | grep -q .; then
    continue
  fi
  [ ! -f "$src_dir/package.nix" ] && continue
  rm -rf "$dest_dir"
  mkdir -p "$dest_dir"
  cp "$src_dir/package.nix" "$dest_dir/default.nix"
  for f2 in "$src_dir"/*; do
    bn=$(basename "$f2")
    [ "$bn" = "package.nix" ] && continue
    cp -r "$f2" "$dest_dir/"
  done
  apply_tx "$dest_dir/default.nix"
  if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "$pkg" >> /tmp/r12go-eval-pass.txt
  else
    echo "$pkg" >> /tmp/r12go-fail-eval.txt
    rm -rf "$dest_dir"
  fi
  echo -ne "\r[$idx/$total]"
done < /tmp/r12-batch-ab
echo ""
echo "Eval pass: $(wc -l < /tmp/r12go-eval-pass.txt)"
echo "Eval fail: $(wc -l < /tmp/r12go-fail-eval.txt)"

# PHASE 2: Bulk build (no timeout - let it run as long as needed)
echo "=== PHASE 2: Bulk Build ==="
build_args=""
while read pkg; do
  build_args="$build_args -A $pkg"
done < /tmp/r12go-eval-pass.txt
nix-build $build_args --no-out-link --keep-going > /tmp/r12go-bulk.log 2>&1 || true
echo "Bulk build complete"

# PHASE 3: Individual check + commit
echo "=== PHASE 3: Commit ==="
while read pkg; do
  dest_dir="pkgs/${pkg}"
  [ ! -d "$dest_dir" ] && continue
  if nix-build -A "$pkg" --no-out-link >/dev/null 2>&1; then
    version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")
    $NIXFMT "$dest_dir/default.nix" 2>/dev/null || true
    git add "pkgs/${pkg}/"
    git commit -m "${pkg}: init at ${version}"
    echo "OK: $pkg ($version)"
    echo "$pkg: $version" >> /tmp/r12go-success.txt
  else
    echo "FAIL(build): $pkg"
    echo "$pkg" >> /tmp/r12go-fail-build.txt
    rm -rf "$dest_dir"
  fi
done < /tmp/r12go-eval-pass.txt

echo ""
echo "=== FINAL ==="
echo "SUCCESS: $(wc -l < /tmp/r12go-success.txt)"
echo "FAIL(eval): $(wc -l < /tmp/r12go-fail-eval.txt)"
echo "FAIL(build): $(wc -l < /tmp/r12go-fail-build.txt)"
echo ""
cat /tmp/r12go-success.txt
