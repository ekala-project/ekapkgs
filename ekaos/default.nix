# EkaOS system builder for ekapkgs
# Delegates to core-pkgs' eval-config.nix with ekapkgs overlays applied
{
  system ? "x86_64-linux",
  pkgs ? import ../. { inherit system; },
  lib ? pkgs.lib,
  configuration,
}:

let
  pins = import ../pins.nix;

  ekapkgsModules = import ./modules/module-list.nix;

  eval =
    (import (pins.corepkgs + "/ekaos/eval-config.nix") {
      inherit lib pkgs;
    })
      {
        modules = ekapkgsModules ++ [ configuration ];
      };
in

eval
