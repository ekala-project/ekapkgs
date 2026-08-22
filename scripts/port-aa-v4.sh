#!/usr/bin/env bash
# Port batch-aa v4 - practical approach
# Copy/transform/eval/build/commit each package with 120s build timeout

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH="/tmp/r12-batch-aa"
RESULTS="/tmp/aa4-results.txt"
FAILLOG="/tmp/aa4-faillog.txt"

> "$RESULTS"
> "$FAILLOG"

declare -i ok=0
declare -i skip=0
declare -i evalfail=0
declare -i buildfail=0

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

while IFS= read -r pkg || [ -n "$pkg" ]; do
  [ -z "$pkg" ] && continue

  # Skip already committed
  if git ls-files --error-unmatch "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    skip+=1
    continue
  fi

  # Clean any leftover
  [ -d "pkgs/$pkg" ] && rm -rf "pkgs/$pkg"

  # Find source
  first_two="${pkg:0:2}"
  src="$NIXPKGS/pkgs/by-name/$first_two/$pkg/package.nix"
  [ ! -f "$src" ] && { echo "NOSRC $pkg" >> "$RESULTS"; skip+=1; continue; }

  # Copy
  mkdir -p "pkgs/$pkg"
  cp "$src" "pkgs/$pkg/default.nix"
  for f in "$NIXPKGS/pkgs/by-name/$first_two/$pkg"/*; do
    bn="$(basename "$f")"
    [ "$bn" = "package.nix" ] && continue
    [ -d "$f" ] && cp -r "$f" "pkgs/$pkg/" || cp "$f" "pkgs/$pkg/$bn"
  done

  # Transform
  transform "pkgs/$pkg/default.nix"

  # Format
  if ! "$NIXFMT" "pkgs/$pkg/default.nix" >/dev/null 2>&1; then
    echo "FMTFAIL $pkg" >> "$RESULTS"
    rm -rf "pkgs/$pkg"
    evalfail+=1
    continue
  fi

  # Eval
  if ! nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "EVALFAIL $pkg" >> "$RESULTS"
    rm -rf "pkgs/$pkg"
    evalfail+=1
    continue
  fi

  # Build (120s timeout - catch fast builds, skip slow ones)
  if timeout 120 nix-build -A "$pkg" --timeout 120 --no-out-link >> "$FAILLOG" 2>&1; then
    ver=$(grep -oP 'version\s*=\s*"\K[^"]*' "pkgs/$pkg/default.nix" | head -1)
    [ -z "$ver" ] && ver="unknown"
    git add "pkgs/$pkg/"
    git commit -m "$pkg: init at $ver"
    echo "OK $pkg $ver" >> "$RESULTS"
    ok+=1
    echo "OK $pkg $ver"
  else
    echo "BUILDFAIL $pkg" >> "$RESULTS"
    rm -rf "pkgs/$pkg"
    buildfail+=1
  fi
done < "$BATCH"

echo ""
echo "=== DONE ==="
echo "Committed: $ok"
echo "Eval fail: $evalfail"
echo "Build fail: $buildfail"
echo "Skip: $skip"
echo "Total: $((ok + evalfail + buildfail + skip))"
