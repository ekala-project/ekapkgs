# Unified list of all derivations contributed by ekapkgs.
#
# This includes:
#   - Native packages from pkgs/ and top-level.nix
#   - Python package overrides from python-packages.nix
#
# Used by ekapkgs-update to enumerate packages for automated updates.
{ ... }:
let
  pins = import ../pins.nix;
  lib = import pins.lib;
  pkgsModule = import ../pkgs-module.nix;
  pkgs = import ../. {
    modules = [ pkgsModule ];
  };
  mkProjection = overlay: base: lib.fix (self: base // overlay self base);

  # Check whether a value is a derivation whose drvPath can be forced.
  isBuildable =
    value:
    let
      result = builtins.tryEval (lib.isDerivation value && builtins.seq value.drvPath true);
    in
    result.success && result.value;

  # --- Native packages (pkgs/ directory + top-level.nix overrides) ---
  nativeOverlay = lib.packageSets.mkAutoCalledPackageDir ../pkgs;
  nativeOverrides = import ../top-level.nix;
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
  pythonOverrides = import ../python-packages.nix;
  projectedPython = mkProjection pythonOverrides pkgs.python3Packages;
  pythonOverlayKeys = pythonOverrides (_: _: { }) { };
  pythonPkgs = removeAttrs (builtins.intersectAttrs pythonOverlayKeys projectedPython) [
    "_internalCallByNamePackageFile"
  ];

  all = nativePkgs // pythonPkgs;

  topLevel = map (name: {
    inherit name;
    value = all.${name};
  }) (builtins.attrNames all);
in
{
  inherit all;

  # Attribute set of all buildable derivations, keyed by name.
  buildable = builtins.listToAttrs (builtins.filter (pair: isBuildable pair.value) topLevel);
}
