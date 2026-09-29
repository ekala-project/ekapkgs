# Elm programming language module
{
  config,
  lib,
  pkgs,
  ...
}:

let
  langLib = import ./lib.nix { inherit lib; };
  mod = langLib.mkLanguageModule {
    name = "elm";
    defaultPackage = pkgs: pkgs.elm;
  };
in

mod { inherit config lib pkgs; }
