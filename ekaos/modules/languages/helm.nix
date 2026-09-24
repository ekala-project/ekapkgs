# Helm language module
{
  config,
  lib,
  pkgs,
  ...
}:

let
  langLib = import ./lib.nix { inherit lib; };
  mod = langLib.mkLanguageModule {
    name = "helm";
    defaultPackage = pkgs: pkgs.kubernetes-helm;
    defaultLspPackage = pkgs: pkgs.helm-ls;
  };
in

mod { inherit config lib pkgs; }
