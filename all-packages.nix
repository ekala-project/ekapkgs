# all-packages.nix — Flatten all ekapkgs derivations into a single attribute set.
#
# This collects every derivation from the ekapkgs package set, including
# nested package scopes (haskellPackages, python3Packages, etc.) and
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
    config = { allowUnfree = true; };
    modules = [ pkgsModule ];
  };

  inherit (builtins) tryEval isAttrs attrNames listToAttrs concatLists;

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
      let variantNames = tryAttr (attrNames variants);
      in
      if variantNames == null then [ ]
      else
      concatLists (map (
        vname:
        let val = tryAttr variants.${vname};
        in if val != null && lib.isDerivation val then
          [ { name = "${name}-${vname}"; value = val; } ]
        else
          [ ]
      ) variantNames)
    else
      [ ];

  # Known package scopes to recurse into
  packageScopes = [
    "cudaPackages"
    "haskellPackages"
    "linuxPackages"
    "perlPackages"
    "python3Packages"
    "rPackages"
    "texlive"
    "texlivePackages"
    "vimPlugins"
    "xorg"
  ];

  # Collect derivations from top-level pkgs
  collectTopLevel =
    concatLists (map (
      name:
      let
        val = tryAttr pkgs.${name};
      in
      if val == null then [ ]
      else if lib.isDerivation val then
        [ { inherit name; value = val; } ] ++ collectVariants name val
      else [ ]
    ) (attrNames pkgs));

  # Collect derivations from a named scope
  collectScope = scopeName:
    let
      scope = tryAttr pkgs.${scopeName};
      names = if scope != null then tryAttr (attrNames scope) else null;
    in
    if names == null then [ ]
    else
      lib.concatMap (
        name:
        let
          fullName = "${scopeName}.${name}";
          rawResult = tryEval (builtins.seq scope.${name} scope.${name});
        in
        if !rawResult.success then [ ]
        else
          let val = rawResult.value;
          in
          if lib.isDerivation val then
            [ { name = fullName; value = val; } ]
          else [ ]
      ) names;

  allScopes = concatLists (map collectScope packageScopes);

  collected = listToAttrs (collectTopLevel ++ allScopes);
in
collected // { recurseForDerivations = true; }
