# Unified list of all derivations contributed by ekapkgs.
#
# This includes:
#   - Native packages from pkgs/ and top-level.nix
#   - Multi-variant packages from pkgs-many/ (each variant enumerated)
#   - Python package overrides from python-packages.nix
#   - Perl packages from perl/pkgs/
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

  # --- Multi-variant packages (pkgs-many/) ---
  pkgsManyOverlay = lib.packageSets.mkAutoCalledManyVariantsDir ../pkgs-many;
  projectedMany = mkProjection pkgsManyOverlay pkgs;
  pkgsManyKeys = pkgsManyOverlay (_: _: { }) { };
  manyPkgs = removeAttrs (builtins.intersectAttrs pkgsManyKeys projectedMany) [
    "_internalCallByNamePackageFile"
  ];

  # Collect each variant sub-derivation from pkgs-many packages.
  variantPairs = lib.concatMap (
    name:
    let
      raw = builtins.tryEval manyPkgs.${name};
    in
    if !raw.success then
      [ ]
    else
      let
        variants = builtins.tryEval (raw.value.variants or null);
      in
      if !variants.success || variants.value == null then
        [ ]
      else
        map (vname: {
          name = "${name}.${vname}";
          value = variants.value.${vname};
        }) (builtins.attrNames variants.value)
  ) (builtins.attrNames manyPkgs);

  # --- Python package overrides (python-packages.nix) ---
  pythonOverrides = import ../python-packages.nix;
  projectedPython = mkProjection pythonOverrides pkgs.python3Packages;
  pythonOverlayKeys = pythonOverrides (_: _: { }) { };
  pythonPkgs = removeAttrs (builtins.intersectAttrs pythonOverlayKeys projectedPython) [
    "_internalCallByNamePackageFile"
  ];

  # --- Perl packages (perl/pkgs/) ---
  perlOverlay = lib.packageSets.mkAutoCalledPackageDir ../perl/pkgs;
  projectedPerl = mkProjection perlOverlay pkgs.perlPackages;
  perlOverlayKeys = perlOverlay (_: _: { }) { };
  perlPkgs = removeAttrs (builtins.intersectAttrs perlOverlayKeys projectedPerl) [
    "_internalCallByNamePackageFile"
  ];

  # --- Flatten all into named pairs ---
  mkPairs =
    prefix: attrs:
    map (name: {
      name = if prefix == "" then name else "${prefix}.${name}";
      value = attrs.${name};
    }) (builtins.attrNames attrs);

  allPairs =
    mkPairs "" nativePkgs
    ++ variantPairs
    ++ mkPairs "python3Packages" pythonPkgs
    ++ mkPairs "perlPackages" perlPkgs;
in
{
  # Flat attribute set of everything (for ekapkgs-update).
  all = nativePkgs // pythonPkgs // perlPkgs;

  # Attribute set of all buildable derivations, keyed by name.
  buildable = builtins.listToAttrs (builtins.filter (pair: isBuildable pair.value) allPairs);
}
