{ mkManyVariants, callPackage }:

mkManyVariants {
  variants = ./variants.nix;
  aliases = { };
  defaultSelector = (p: p.v4);
  genericBuilder = ./generic.nix;
  inherit callPackage;
}
