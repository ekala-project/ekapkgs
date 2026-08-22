#!/usr/bin/env bash
# Phase 1: Copy, transform, format, and eval-check all packages
# Outputs: /tmp/port-eval-pass.txt and /tmp/port-eval-fail.txt

EKAPKGS="/home/jon/projects/ekapkgs"
NIXPKGS="/home/jon/projects/nixpkgs"
NIXFMT="/nix/store/mhi45zliliv6qhvhb8g5sycy3jpv47rf-nixfmt-1.3.1/bin/nixfmt"
BATCH_FILE="${1:-/tmp/r12-batch-aa}"

> /tmp/port-eval-pass.txt
> /tmp/port-eval-fail.txt
> /tmp/port-eval-skip.txt

transform_file() {
  local dest="$1"

  # Remove nix-update-script from inputs
  sed -i '/^[[:space:]]*nix-update-script\s*,\?\s*$/d' "$dest"
  # Remove gitUpdater from inputs
  sed -i '/^[[:space:]]*gitUpdater\s*,\?\s*$/d' "$dest"
  # Remove versionCheckHook from inputs
  sed -i '/^[[:space:]]*versionCheckHook\s*,\?\s*$/d' "$dest"
  # Remove nixosTests from inputs
  sed -i '/^[[:space:]]*nixosTests\s*,\?\s*$/d' "$dest"
  # Remove passthru.updateScript (single line)
  sed -i '/^\s*passthru\.updateScript\s*=/d' "$dest"
  # Remove updateScript inside passthru blocks
  sed -i '/^\s*updateScript\s*=/d' "$dest"
  # Remove multi-line passthru.updateScript = { ... };
  perl -0777 -i -pe 's/\s*passthru\.updateScript\s*=\s*\{[^}]*\}\s*;\s*\n?//gs' "$dest"
  # Remove nixosTests references
  sed -i '/nixosTests\./d' "$dest"
  # Set meta.maintainers = [ ]
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[([^\]]*)\]/maintainers = [ ]/gs' "$dest"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[\s*(?:lib\.maintainers\.\w+\s*)*\]/maintainers = [ ]/gs' "$dest"
  # Add cmake.configurePhaseHook
  if grep -Pq '^\s+cmake\s*$' "$dest" 2>/dev/null; then
    if ! grep -q 'cmake\.configurePhaseHook' "$dest"; then
      sed -i '/^\s\+cmake\s*$/a\    cmake.configurePhaseHook' "$dest"
    fi
  fi
  # Add meson.configurePhaseHook
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
    echo "$pkg" >> /tmp/port-eval-skip.txt
    continue
  fi

  # Clean leftover
  [ -d "pkgs/$pkg" ] && rm -rf "pkgs/$pkg"

  first_two="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/$first_two/$pkg"
  src_file="$src_dir/package.nix"

  if [ ! -f "$src_file" ]; then
    echo "$pkg NOSRC" >> /tmp/port-eval-fail.txt
    continue
  fi

  mkdir -p "pkgs/$pkg"
  cp "$src_file" "pkgs/$pkg/default.nix"

  # Copy extra files
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
    echo "$pkg FMTFAIL" >> /tmp/port-eval-fail.txt
    rm -rf "pkgs/$pkg"
    continue
  fi

  if nix-instantiate -A "$pkg" >/dev/null 2>&1; then
    echo "$pkg" >> /tmp/port-eval-pass.txt
    echo "PASS $pkg"
  else
    echo "$pkg EVALFAIL" >> /tmp/port-eval-fail.txt
    rm -rf "pkgs/$pkg"
    echo "FAIL $pkg"
  fi
done < "$BATCH_FILE"

echo ""
echo "=== Phase 1 Complete ==="
echo "Eval pass: $(wc -l < /tmp/port-eval-pass.txt)"
echo "Eval fail: $(wc -l < /tmp/port-eval-fail.txt)"
echo "Skipped: $(wc -l < /tmp/port-eval-skip.txt)"
