# pkgs-module.nix — Expose ekapkgs overlays for downstream consumption.
#
# This aggregates all upstream language repo overlays/modules plus ekapkgs' own.
#
# Returns an attrset with:
#   overlays — all top-level overlays (upstream + ekapkgs)
#   module   — NixOS module for config.overlays.* (currently empty for ekapkgs itself)
#   modules  — all upstream NixOS modules (for downstream to include)
let
  pins = import ./pins.nix;
  lib = import pins.lib;

  # Import upstream pkgs-modules
  pythonPkgsModule = import (pins.python + "/pkgs-module.nix");
  haskellPkgsModule = import (pins.haskell + "/pkgs-module.nix");
  # nodePkgsModule = import (pins.node + "/pkgs-module.nix");

  allPkgsModules = [
    pythonPkgsModule
    # haskellPkgsModule
    # nodePkgsModule
  ];

  # ekapkgs' own overlays
  pkgsOverlay = lib.packageSets.mkAutoCalledPackageDir ./pkgs;
  pkgsOverrides = import ./top-level.nix;
in
{
  imports = allPkgsModules;

  overlays.pkgs = [
    pkgsOverlay
    pkgsOverrides
  ];
}
