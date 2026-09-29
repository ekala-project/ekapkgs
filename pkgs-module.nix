# pkgs-module.nix — Expose ekapkgs overlays for downstream consumption.
#
# This aggregates all upstream language repo overlays/modules plus ekapkgs' own.
#
# Returns an attrset with:
#   overlays — all top-level overlays (upstream + ekapkgs)
#   module   — NixOS module for config.overlays.* (currently empty for ekapkgs itself)
#   modules  — all upstream NixOS modules (for downstream to include)
{ lib, config, ... }:
let
  pins = import ./pins.nix;

  # Import upstream pkgs-modules
  pythonPkgsModule = import (pins.python + "/pkgs-module.nix");
  haskellPkgsModule = import (pins.haskell + "/pkgs-module.nix");
  cudaPkgsModule = import (pins.cuda + "/pkgs-module.nix");
  rPkgsModule = import (pins.r-pkgs + "/pkgs-module.nix");
  vimModule = import (pins.vim-plugins + "/pkgs-module.nix");

  allPkgsModules = [
    cudaPkgsModule
    pythonPkgsModule
    haskellPkgsModule
    haskellPkgsModule
    rPkgsModule
    vimModule
  ];

  # ekapkgs' own overlays
  pkgsOverlay = lib.packageSets.mkAutoCalledPackageDir ./pkgs;
  pkgsManyOverlay = lib.packageSets.mkAutoCalledManyVariantsDir ./pkgs-many;
  pkgsOverrides = import ./top-level.nix;
  nixpkgsAliases = self: super: import ./aliases/nixpkgs.nix lib self super;
  pythonAutoCallOverlay = lib.packageSets.mkAutoCalledPackageDir ./python/pkgs;
  pythonOverrides = import ./python-packages.nix;
  perlOverrides = lib.packageSets.mkAutoCalledPackageDir ./perl/pkgs;

  writersOverlay = lib.packageSets.mkAutoCalledPackageDir ./writers/pkgs;

  # Fix haskell lua ecosystem: the Haskell 'lua' package depends on system
  # lua5_4 via librarySystemDepends, but dependent packages (lpeg, hslua-core,
  # hslua-list, etc.) don't get the headers/libs propagated.  Fix the root
  # cause by overriding the 'lua' Haskell package to add lua5_4 to
  # propagatedBuildInputs so all transitive dependents get the C headers.
  haskellFixes = final: prev: {
    lua = prev.lua.overrideAttrs (old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ prev.pkgs.lua.v5_4 ];
    });
  };
in
{
  imports = allPkgsModules;

  overlays.pkgs = [
    pkgsOverlay
    pkgsManyOverlay
    pkgsOverrides
  ]
  ++ lib.optional config.aliases.nixpkgs nixpkgsAliases;

  overlays.python = [
    pythonAutoCallOverlay
    pythonOverrides
  ];

  overlays.perl = [
    perlOverrides
  ];

  overlays.haskell = [
    haskellFixes
  ];

  overlays.writers = [
    writersOverlay
  ];
}
