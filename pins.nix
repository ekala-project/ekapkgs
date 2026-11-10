# Pins are read from flake.lock; update them with `nix flake update`.
let
  fetchLocked = import ./fetch-locked.nix { };
in
{
  lib = fetchLocked "nix-lib";
  corepkgs = fetchLocked "corepkgs";
  python = fetchLocked "python";
  haskell = fetchLocked "haskell";
  cuda = fetchLocked "cuda";
  r-pkgs = fetchLocked "r-pkgs";
  vim-plugins = fetchLocked "vim-plugins";
}
