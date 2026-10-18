{ mkManyVariants, callPackage }:

mkManyVariants {
  variants = ./variants.nix;
  aliases = { };
  defaultSelector = (p: p.v140);
  genericBuilder = ./generic.nix;
  inherit callPackage;
}
