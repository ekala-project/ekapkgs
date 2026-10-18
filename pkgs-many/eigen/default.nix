{ mkManyVariants, callPackage }:

mkManyVariants {
  variants = ./variants.nix;
  aliases = { };
  defaultSelector = (p: p.v5);
  genericBuilder = ./generic.nix;
  inherit callPackage;
}
