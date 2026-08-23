# Unified list of all derivations contributed by ekapkgs.
#
# This includes:
#   - Native packages from pkgs/ and top-level.nix
#   - Python package overrides from python-packages.nix
#
# Used by ekapkgs-update to enumerate packages for automated updates.
{ ... }:
let
  pins = import ./pins.nix;
  lib = import pins.lib;
  pkgsModule = import ./pkgs-module.nix;
  pkgs = import ./. {
    modules = [ pkgsModule ];
  };
  mkProjection = overlay: base: lib.fix (self: base // overlay self base);

  # --- Native packages (pkgs/ directory + top-level.nix overrides) ---
  nativeOverlay = lib.packageSets.mkAutoCalledPackageDir ./pkgs;
  nativeOverrides = import ./top-level.nix;
  combinedNativeOverlay = lib.composeManyExtensions [
    nativeOverlay
    nativeOverrides
  ];
  projectedNative = mkProjection combinedNativeOverlay pkgs;
  nativeOverlayKeys = combinedNativeOverlay (_: _: { }) { };
  nativePkgs = removeAttrs (builtins.intersectAttrs nativeOverlayKeys projectedNative) [
    "_internalCallByNamePackageFile"
  ];

  # --- Python package overrides (python-packages.nix) ---
  pythonOverrides = import ./python-packages.nix;
  projectedPython = mkProjection pythonOverrides pkgs.python3Packages;
  pythonOverlayKeys = pythonOverrides (_: _: { }) { };
  pythonPkgs = removeAttrs (builtins.intersectAttrs pythonOverlayKeys projectedPython) [
    "_internalCallByNamePackageFile"
  ];
in
nativePkgs // pythonPkgs
