# Dart programming language module
{
  config,
  lib,
  pkgs,
  ...
}:

let
  langLib = import ./lib.nix { inherit lib; };
  mod = langLib.mkLanguageModule {
    name = "dart";
    defaultPackage = pkgs: pkgs.dart;
  };
in

mod { inherit config lib pkgs; }
