#!/usr/bin/env bash
# Port batch-aa packages v3 - resilient version
# Phase 1: Copy/transform/format/eval
# Phase 2: Bulk build with --keep-going (builds deps in parallel)
# Phase 3: Individual build + commit (should be fast after phase 2)

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH="/tmp/r12-batch-aa"
PASS="/tmp/aa3-pass.txt"
FAIL="/tmp/aa3-fail.txt"
BUILDLOG="/tmp/aa3-buildlog.txt"

> "$PASS"
> "$FAIL"
> "$BUILDLOG"

transform() {
  local f="$1"
  sed -i '/^[[:space:]]*nix-update-script\s*,\?\s*$/d' "$f"
  sed -i '/^[[:space:]]*gitUpdater\s*,\?\s*$/d' "$f"
  sed -i '/^[[:space:]]*versionCheckHook\s*,\?\s*$/d' "$f"
  sed -i '/^[[:space:]]*nixosTests\s*,\?\s*$/d' "$f"
  sed -i '/^\s*passthru\.updateScript\s*=/d' "$f"
  sed -i '/^\s*updateScript\s*=/d' "$f"
  perl -0777 -i -pe 's/\s*passthru\.updateScript\s*=\s*\{[^}]*\}\s*;\s*\n?//gs' "$f"
  sed -i '/nixosTests\./d' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*)\]/maintainers = [ ]/gs' "$f"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(?:lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$f"
  if grep -Pq '^\s+cmake\s*$' "$f" 2>/dev/null; then
    grep -q 'cmake\.configurePhaseHook' "$f" || sed -i '/^\s\+cmake\s*$/a\    cmake.configurePhaseHook' "$f"
  fi
  if grep -Pq '^\s+meson\s*$' "$f" 2>/dev/null; then
    grep -q 'meson\.configurePhaseHook' "$f" || sed -i '/^\s\+meson\s*$/a\    meson.configurePhaseHook' "$f"
  fi
  sed -i '/^$/N;/^\n$/d' "$f"
}

cd "$EKAPKGS"

echo "=== PHASE 1: Copy/transform/eval ==="
while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1 && continue
  [ -d "pkgs/$pkg" ] && rm -rf "pkgs/$pkg"

  first_two="${pkg:0:2}"
  src="$NIXPKGS/pkgs/by-name/$first_two/$pkg/package.nix"
  [ ! -f "$src" ] && { echo "NOSRC $pkg" >> "$FAIL"; continue; }

  mkdir -p "pkgs/$pkg"
  cp "$src" "pkgs/$pkg/default.nix"
  for f in "$NIXPKGS/pkgs/by-name/$first_two/$pkg"/*; do
    bn="$(basename "$f")"
    [ "$bn" = "package.nix" ] && continue
    [ -d "$f" ] && cp -r "$f" "pkgs/$pkg/" || cp "$f" "pkgs/$pkg/$bn"
  done

  transform "pkgs/$pkg/default.nix"
  "$NIXFMT" "pkgs/$pkg/default.nix" >/dev/null 2>&1 || { echo "FMTFAIL $pkg" >> "$FAIL"; rm -rf "pkgs/$pkg"; continue; }
  nix-instantiate -A "$pkg" >/dev/null 2>&1 || { echo "EVALFAIL $pkg" >> "$FAIL"; rm -rf "pkgs/$pkg"; continue; }
  echo "$pkg" >> "$PASS"
done < "$BATCH"

pass_count=$(wc -l < "$PASS")
echo "Phase 1: $pass_count pass, $(wc -l < "$FAIL") fail"

echo "=== PHASE 2: Bulk build (90 min max) ==="
# Build all eval-passing packages in one go, letting nix parallelize
args=$(sed 's/^/-A /' "$PASS" | tr '\n' ' ')
timeout 5400 nix-build $args --no-out-link --keep-going --timeout 600 >> "$BUILDLOG" 2>&1 || true
echo "Bulk build done"

echo "=== PHASE 3: Commit successful packages ==="
declare -i ok=0
declare -i bad=0

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1 && continue
  [ ! -f "pkgs/$pkg/default.nix" ] && { bad+=1; echo "NODIR $pkg" >> "$FAIL"; continue; }

  # Quick build attempt (2 min) - should be instant if bulk build succeeded
  if timeout 120 nix-build -A "$pkg" --timeout 120 --no-out-link >> "$BUILDLOG" 2>&1; then
    ver=$(grep -oP 'version\s*=\s*"\K[^"]*' "pkgs/$pkg/default.nix" | head -1)
    [ -z "$ver" ] && ver="unknown"
    git add "pkgs/$pkg/"
    git commit -m "$pkg: init at $ver"
    echo "OK $pkg $ver"
    ok+=1
  else
    echo "BUILDFAIL $pkg" >> "$FAIL"
    rm -rf "pkgs/$pkg"
    bad+=1
  fi
done < "$PASS"

echo ""
echo "=== FINAL ==="
echo "Committed: $ok"
echo "Build fail: $bad"
echo "Eval fail: $(grep -c EVALFAIL "$FAIL" 2>/dev/null || echo 0)"
echo "Total batch: $(wc -l < "$BATCH")"
