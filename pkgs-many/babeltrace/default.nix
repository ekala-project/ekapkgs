{ mkManyVariants, callPackage }:

mkManyVariants {
  variants = ./variants.nix;
  aliases = { };
  defaultSelector = (p: p.v2);
  genericBuilder = ./generic.nix;
  inherit callPackage;
}
