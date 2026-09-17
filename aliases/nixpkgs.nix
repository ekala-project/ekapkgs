lib: final: prev:
let
  inherit (final) pkgs;
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  # Make sure that we are not shadowing something from top-level.nix.
  checkInPkgs =
    n: alias: if builtins.hasAttr n prev then abort "Alias ${n} is still in top-level.nix" else alias;

  mapAliases =
    aliases: lib.mapAttrs (n: alias: removeRecurseForDerivations (checkInPkgs n alias)) aliases;
in
with pkgs;
mapAliases {
  # Nixpkgs compatibility aliases for ekapkgs
  # These map old nixpkgs attribute names to ekapkgs equivalents.

  # webrtc-audio-processing v1 (nixpkgs has both v0 and v1; ekapkgs only has v1)
  webrtc-audio-processing_1 = webrtc-audio-processing;
}
