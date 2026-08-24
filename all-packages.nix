# all-packages.nix — Flatten all ekapkgs derivations into a single attribute set.
#
# This collects every derivation from the ekapkgs package set, including
# any `passthru.variants` sub-derivations, into one flat attr set with
# `recurseForDerivations` enabled.
#
# Usage:
#   nix-instantiate --eval -E 'builtins.length (builtins.attrNames (import ./all-packages.nix {}))'
#   nix-build all-packages.nix -A <name>
#
{ system ? builtins.currentSystem }:
let
  pins = import ./pins.nix;
  lib = import pins.lib;
  pkgsModule = import ./pkgs-module.nix;
  pkgs = import ./. {
    inherit system;
    modules = [ pkgsModule ];
  };

  inherit (builtins) tryEval isAttrs;

  # Safely evaluate an attribute, returning null on error
  tryAttr = attr:
    let result = tryEval attr;
    in if result.success then result.value else null;

  # Collect variants from a derivation's passthru, if present.
  collectVariants = name: drv:
    let
      variants = tryAttr (drv.variants or null);
    in
    if variants != null && isAttrs variants then
      lib.concatMapAttrs (
        vname: vdrv:
        let val = tryAttr vdrv;
        in if val != null && lib.isDerivation val then
          { "${name}-${vname}" = val; }
        else
          { }
      ) variants
    else
      { };

  # Walk the top-level package set, collecting derivations and their variants
  collected = lib.concatMapAttrs (
    name: value:
    let val = tryAttr value;
    in if val != null && lib.isDerivation val then
      { ${name} = val; } // collectVariants name val
    else
      { }
  ) pkgs;
in
collected // { recurseForDerivations = true; }
