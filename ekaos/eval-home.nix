# Standalone home configuration evaluator for ekapkgs
#
# Wraps core-pkgs' eval-home.nix, adding ekapkgs-specific home modules
# (zsh, fish, tmux, kitty, foot, ghostty, wezterm, emacs, neomutt,
# mpv, zathura, dunst, mako, gammastep, darkman, udiskie, cliphist, mpd).
#
# Usage:
#   let
#     pkgs = import ./. { system = "x86_64-linux"; };
#     evalHome = import ./ekaos/eval-home.nix { inherit (pkgs) lib; inherit pkgs; };
#     result = evalHome { modules = [ ./home.nix ]; };
#   in result.activationPackage
{ lib, pkgs }:

let
  pins = import ../pins.nix;
  corepkgsEvalHome = import (pins.corepkgs + "/ekaos/eval-home.nix") {
    inherit lib pkgs;
  };
  ekapkgsHomeModules = import ./modules/home-module-list.nix;
in

{
  modules ? [ ],
  specialArgs ? { },
}:

corepkgsEvalHome {
  modules = ekapkgsHomeModules ++ modules;
  inherit specialArgs;
}
