# Evaluate ekapkgs-contributed packages with nixpkgs aliases enabled.
#
# Unlike ci/packages.nix (aliases disabled, hard errors on deprecated names),
# this file enables aliases so that packages using deprecated names get
# evaluation warnings instead of crashing.  Use it to discover which ported
# packages still rely on nixpkgs compatibility aliases so they can be migrated
# to canonical names.
#
# Usage:
#   nix-instantiate ci/aliases-used.nix 2>&1 | grep "evaluation warning"

let
  pins = import ../pins.nix;
  lib = import pins.lib;
  pkgsModule = import ../pkgs-module.nix;

  pkgs = import ../. {
    modules = [ pkgsModule ];
    config.aliases.nixpkgs = true;
  };

  mkProjection = overlay: base: lib.fix (self: base // overlay self base);

  isBuildable =
    value:
    let
      result = builtins.tryEval (lib.isDerivation value && builtins.seq value.drvPath true);
    in
    result.success && result.value;

  # Only probe packages contributed by ekapkgs (pkgs/ directory).
  nativeOverlay = lib.packageSets.mkAutoCalledPackageDir ../pkgs;
  nativeOverlayKeys = nativeOverlay (_: _: { }) { };
  projectedNative = mkProjection nativeOverlay pkgs;
  nativePkgs = removeAttrs (builtins.intersectAttrs nativeOverlayKeys projectedNative) [
    "_internalCallByNamePackageFile"
  ];

  topLevel = map (name: {
    inherit name;
    value = nativePkgs.${name};
  }) (builtins.attrNames nativePkgs);
in
builtins.listToAttrs (builtins.filter (pair: isBuildable pair.value) topLevel)
