#!/usr/bin/env bash
# Port batch-aa packages - all-in-one, fast
# Phase 1: Copy/transform/format/eval all packages
# Phase 2: Build ALL at once with --keep-going
# Phase 3: Try each individually, commit successes

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH="/tmp/r12-batch-aa"
LOG="/tmp/aa2-log.txt"
PASS="/tmp/aa2-pass.txt"
FAIL="/tmp/aa2-fail.txt"

> "$LOG"
> "$PASS"
> "$FAIL"

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

echo "Phase 1 done: $(wc -l < "$PASS") pass, $(wc -l < "$FAIL") fail"

echo "=== PHASE 2: Bulk build ==="
args=$(sed 's/^/-A /' "$PASS" | tr '\n' ' ')
# Build everything at once, --keep-going continues past failures
# Use --timeout 600 per individual derivation
timeout 5400 nix-build $args --no-out-link --keep-going --timeout 600 >> "$LOG" 2>&1
echo "Bulk build exit: $?"

echo "=== PHASE 3: Individual build & commit ==="
declare -i ok=0
declare -i bad=0

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue
  git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1 && continue
  [ ! -f "pkgs/$pkg/default.nix" ] && { bad+=1; continue; }

  # Try building - should be instant if bulk build succeeded
  if timeout 120 nix-build -A "$pkg" --timeout 120 --no-out-link >> "$LOG" 2>&1; then
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
echo "=== DONE ==="
echo "Committed: $ok"
echo "Build fail: $bad"
echo "Eval fail: $(grep -c EVALFAIL "$FAIL" 2>/dev/null)"
echo "Total: $(wc -l < "$BATCH")"
