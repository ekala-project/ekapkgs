#!/usr/bin/env bash
# Fails if an EkaOS module list names a file that does not exist.
#
# A dangling entry breaks every system that imports the list, but nothing in
# ci/eval.sh evaluates an EkaOS system, so it would otherwise go unnoticed.
# This only needs builtins, so it is cheap: no package set is evaluated.

set -euo pipefail

cd "$(dirname "$0")/.."

status=0
for list in ekaos/modules/module-list.nix ekaos/modules/home-module-list.nix; do
  missing="$(nix-instantiate --eval --strict --json --expr "
    map toString (builtins.filter (p: !builtins.pathExists p) (import ./$list))
  ")"
  if [[ "$missing" != "[]" ]]; then
    echo "$list lists files that do not exist:" >&2
    tr -d '[]"' <<<"$missing" | tr ',' '\n' | sed "s|^$PWD/|  |" >&2
    status=1
  fi
done

if [[ "$status" -eq 0 ]]; then
  echo "All EkaOS module list entries exist."
fi
exit "$status"
