# EkaOS system builder for ekapkgs
# Delegates to core-pkgs' eval-config.nix with ekapkgs overlays applied
#
# Usage (from a flake):
#
#   ekapkgs.lib.ekaosSystem {
#     system = "x86_64-linux";
#     config.allowUnfree = true;
#     modules = [ ./configuration.nix ];
#   };
#
# Usage (without flakes):
#
#   import "${ekapkgs}/ekaos" { configuration = ./configuration.nix; }
#
# Any other arguments are passed through to corepkgs' eval-config.nix,
# which hands them to the modules as extra module arguments (specialArgs).
{
  system ? "x86_64-linux",
  # Package set configuration, e.g. { allowUnfree = true; }
  config ? { },
  pkgs ? import ../. { inherit system config; },
  lib ? pkgs.lib,
  configuration ? { },
  modules ? [ ],
  ...
}@args:

let
  pins = import ../pins.nix;

  ekapkgsModules = import ./modules/module-list.nix;

  eval =
    (import (pins.corepkgs + "/ekaos/eval-config.nix") {
      inherit lib pkgs;
    })
      (
        {
          modules = ekapkgsModules ++ [ configuration ] ++ modules;
        }
        // builtins.removeAttrs args [
          "system"
          "config"
          "pkgs"
          "lib"
          "configuration"
          "modules"
        ]
      );
in

eval
