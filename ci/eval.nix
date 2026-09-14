# Evaluates every package in the repository.
#
# checkMeta is disabled because the corepkgs meta checker currently
# rejects valid keys (maintainers, teams).  Corepkgs CI already
# validates its own packages with checkMeta; this gate focuses on
# eval correctness of the ekapkgs overlay.
#
# See ci/packages.nix for what counts as a failure.
#
# Usage:
#   nix-instantiate --eval --strict ci/eval.nix

let
  packages = import ./packages.nix { };
  inherit (packages) probe targets;
in
builtins.deepSeq (map probe targets) {
  evaluated = builtins.length targets;
}
