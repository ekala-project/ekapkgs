let
  pins = import ./pins.nix;

  inherit (pins) lib;

  coreRepo = import pins.core;

  # Import pkgs-module.nix from each language repo
  pythonPkgsModule = import (pins.python + "/pkgs-module.nix");
  haskellPkgsModule = import (pins.haskell + "/pkgs-module.nix");
  nodePkgsModule = import (pins.node + "/pkgs-module.nix");

  # Collect all upstream pkgs-modules
  allPkgsModules = [
    pythonPkgsModule
    haskellPkgsModule
    nodePkgsModule
  ];

  # Collect top-level overlays from all language repos
  upstreamOverlays = builtins.concatLists (map (m: m.overlays) allPkgsModules);

  # Collect NixOS modules for config.overlays.* from all language repos
  upstreamModules = map (m: m.module) allPkgsModules;

  # ekapkgs' own overlays
  # ekapkgsOverlay = lib.mkAutoCalledPackageDir ./pkgs;
  toplevelOverlay = import ./top-level.nix;
in

# Continuation passing style of import
# Values we care to modify are modified, while all other
# arguments are "passed through" to the next scope
{ overlays ? [], config ? {}, modules ? [], ... }@args:

let
  filteredAttrs = builtins.removeAttrs args [ "overlays" "config" "modules" ];
in

coreRepo ({
  overlays =
    upstreamOverlays
    ++ [
      # ekapkgsOverlay
      toplevelOverlay
    ]
    ++ overlays;

  inherit config;

  modules =
    upstreamModules
    ++ modules;
} // filteredAttrs)
