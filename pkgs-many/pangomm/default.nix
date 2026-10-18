{ mkManyVariants, callPackage }:

mkManyVariants {
  variants = ./variants.nix;
  aliases = { };
  defaultSelector = (p: p.v2_46);
  genericBuilder = ./generic.nix;
  inherit callPackage;
}
