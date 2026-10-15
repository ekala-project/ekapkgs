{ lib, callPackage }:

let
  infoJson = builtins.fromJSON (builtins.readFile ./info.json);
  mkElectron = callPackage ./generic.nix { };
in
lib.mapAttrs' (
  majorVersion: info:
  lib.nameValuePair "electron_${majorVersion}" (mkElectron info.version info.hashes)
) infoJson
