# shadowed-packages.nix — Discover ekapkgs packages that shadow corepkgs.
#
# After bumping the corepkgs pin, run:
#   nix-instantiate --eval --strict shadowed-packages.nix -A all --json | jq .
#
# Packages in `pkgsDir` are safe candidates for removal.
# Packages in `topLevel` are intentional overrides — review before removing.
let
  pins = import ./pins.nix;

  inherit (builtins)
    readDir
    attrNames
    filter
    intersectAttrs
    length
    listToAttrs
    mapAttrs
    ;

  # Directory names → attrset with true values (for intersectAttrs)
  dirKeys =
    path:
    let
      entries = readDir path;
    in
    listToAttrs (
      map (n: {
        name = n;
        value = true;
      }) (filter (n: entries.${n} == "directory") (attrNames entries))
    );

  # Extract attribute names from an overlay without evaluating values
  overlayKeys = overlay: mapAttrs (_: _: true) (overlay (_: _: { }) { });

  # --- corepkgs keys ---
  corepkgsAll =
    dirKeys (pins.corepkgs + "/pkgs")
    // dirKeys (pins.corepkgs + "/pkgs-many")
    // overlayKeys (import (pins.corepkgs + "/top-level.nix"));

  # --- ekapkgs keys ---
  ekapkgsPkgs = dirKeys ./pkgs;
  ekapkgsToplevel = overlayKeys (import ./top-level.nix);

  # --- intersection by source ---
  shadowedPkgsDir = intersectAttrs corepkgsAll ekapkgsPkgs;
  shadowedTopLevel = intersectAttrs corepkgsAll ekapkgsToplevel;
  allShadowed = shadowedPkgsDir // shadowedTopLevel;
in
{
  all = attrNames allShadowed;
  pkgsDir = attrNames shadowedPkgsDir;
  topLevel = attrNames shadowedTopLevel;
  count = length (attrNames allShadowed);
}
