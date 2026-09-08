{ mkManyVariants, callPackage }:

let
  mkDiscord = mkManyVariants {
    variants = ./variants.nix;
    aliases = { };
    defaultSelector = (p: p.stable);
    genericBuilder = ./generic.nix;
    inherit callPackage;
  };
in
# mkManyVariants returns an override function; call it to get the derivation
callPackage mkDiscord { }
