let
  # Inherit pinning from flake.lock
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  getInfo =
    attr:
    let
      node = lock.nodes.${attr}.locked;
    in
    if node.type == "path" then
      builtins.fetchTree {
        inherit (node) type path narHash;
      }
    else
      builtins.fetchTree {
        inherit (node)
          type
          owner
          repo
          narHash
          rev
          ;
      };
in
{
  lib = getInfo "lib";
  corepkgs = getInfo "corepkgs";
  python = getInfo "python";
  haskell = getInfo "haskell";
  cuda = getInfo "cuda";
  r-pkgs = getInfo "r-pkgs";
}
