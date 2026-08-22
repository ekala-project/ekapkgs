#!/usr/bin/env bash
# Port packages from batch-aa
# Uses unique filenames to avoid conflicts with other sessions

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH_FILE="/tmp/r12-batch-aa"

# Unique result files for this session
EVAL_PASS="/tmp/aa-eval-pass.txt"
EVAL_FAIL="/tmp/aa-eval-fail.txt"
BUILD_LOG="/tmp/aa-build.log"
RESULTS="/tmp/aa-results.txt"

> "$EVAL_PASS"
> "$EVAL_FAIL"
> "$BUILD_LOG"
> "$RESULTS"

transform_file() {
  local dest="$1"
  sed -i '/^[[:space:]]*nix-update-script\s*,\?\s*$/d' "$dest"
  sed -i '/^[[:space:]]*gitUpdater\s*,\?\s*$/d' "$dest"
  sed -i '/^[[:space:]]*versionCheckHook\s*,\?\s*$/d' "$dest"
  sed -i '/^[[:space:]]*nixosTests\s*,\?\s*$/d' "$dest"
  sed -i '/^\s*passthru\.updateScript\s*=/d' "$dest"
  sed -i '/^\s*updateScript\s*=/d' "$dest"
  perl -0777 -i -pe 's/\s*passthru\.updateScript\s*=\s*\{[^}]*\}\s*;\s*\n?//gs' "$dest"
  sed -i '/nixosTests\./d' "$dest"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*)\]/maintainers = [ ]/gs' "$dest"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(?:lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$dest"
  if grep -Pq '^\s+cmake\s*$' "$dest" 2>/dev/null; then
    if ! grep -q 'cmake\.configurePhaseHook' "$dest"; then
      sed -i '/^\s\+cmake\s*$/a\    cmake.configurePhaseHook' "$dest"
    fi
  fi
  if grep -Pq '^\s+meson\s*$' "$dest" 2>/dev/null; then
    if ! grep -q 'meson\.configurePhaseHook' "$dest"; then
      sed -i '/^\s\+meson\s*$/a\    meson.configurePhaseHook' "$dest"
    fi
  fi
  sed -i '/^$/N;/^\n$/d' "$dest"
}

cd "$EKAPKGS"

echo "=== Phase 1: Copy, transform, eval ==="

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue

  if git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    continue
  fi
  [ -d "pkgs/$pkg" ] && rm -rf "pkgs/$pkg"

  first_two="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/$first_two/$pkg"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "NOSRC $pkg" >> "$EVAL_FAIL"
    continue
  fi

  mkdir -p "pkgs/$pkg"
  cp "$src_file" "pkgs/$pkg/default.nix"
  for f in "$src_dir"/*; do
    fname="$(basename "$f")"
    [ "$fname" = "package.nix" ] && continue
    if [ -d "$f" ]; then
      cp -r "$f" "pkgs/$pkg/"
    elif [ -f "$f" ]; then
      cp "$f" "pkgs/$pkg/$fname"
    fi
  done

  transform_file "pkgs/$pkg/default.nix"

  if ! "$NIXFMT" "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    echo "FMTFAIL $pkg" >> "$EVAL_FAIL"
    rm -rf "pkgs/$pkg"
    continue
  fi

  if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "$pkg" >> "$EVAL_PASS"
  else
    echo "EVALFAIL $pkg" >> "$EVAL_FAIL"
    rm -rf "pkgs/$pkg"
  fi
done < "$BATCH_FILE"

eval_pass_count=$(wc -l < "$EVAL_PASS")
eval_fail_count=$(wc -l < "$EVAL_FAIL")
echo "Eval pass: $eval_pass_count, Eval fail: $eval_fail_count"

echo "=== Phase 2: Build and commit ==="

declare -i success=0
declare -i fail_build=0

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue

  if git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    continue
  fi
  if [ ! -f "pkgs/$pkg/default.nix" ]; then
    continue
  fi

  if timeout 600 nix-build -A "$pkg" --timeout 600 --no-out-link >> "$BUILD_LOG" 2>&1; then
    version=$(grep -oP 'version\s*=\s*"\K[^"]*' "pkgs/$pkg/default.nix" | head -1)
    [ -z "$version" ] && version="unknown"
    git add "pkgs/$pkg/"
    git commit -m "$pkg: init at $version"
    echo "SUCCESS $pkg $version" >> "$RESULTS"
    success+=1
  else
    echo "FAIL_BUILD $pkg" >> "$RESULTS"
    rm -rf "pkgs/$pkg"
    fail_build+=1
  fi
done < "$EVAL_PASS"

echo ""
echo "=== DONE ==="
echo "Build success: $success"
echo "Build fail: $fail_build"
echo "Eval pass: $eval_pass_count"
echo "Eval fail: $eval_fail_count"
echo "Results in $RESULTS"
