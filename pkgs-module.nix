# pkgs-module.nix — Expose ekapkgs overlays for downstream consumption.
#
# This aggregates all upstream language repo overlays/modules plus ekapkgs' own.
#
# Returns an attrset with:
#   overlays — all top-level overlays (upstream + ekapkgs)
#   module   — NixOS module for config.overlays.* (currently empty for ekapkgs itself)
#   modules  — all upstream NixOS modules (for downstream to include)
{ lib, ... }:
let
  pins = import ./pins.nix;

  # Import upstream pkgs-modules
  pythonPkgsModule = import (pins.python + "/pkgs-module.nix");
  haskellPkgsModule = import (pins.haskell + "/pkgs-module.nix");
  cudaPkgsModule = import (pins.cuda + "/pkgs-module.nix");
  rPkgsModule = import (pins.r-pkgs + "/pkgs-module.nix");

  allPkgsModules = [
    cudaPkgsModule
    pythonPkgsModule
    haskellPkgsModule
    haskellPkgsModule
    rPkgsModule
  ];

  # ekapkgs' own overlays
  pkgsOverlay = lib.packageSets.mkAutoCalledPackageDir ./pkgs;
  pkgsOverrides = import ./top-level.nix;
  pythonOverrides = import ./python-packages.nix;
in
{
  imports = allPkgsModules;

  overlays.pkgs = [
    pkgsOverlay
    pkgsOverrides
  ];

  overlays.python = [
    pythonOverrides
  ];
}
