let
  pins = import ./pins.nix;
  coreRepo = import pins.corepkgs;
  pkgsModule = import ./pkgs-module.nix;
in

# Continuation passing style of import
# Values we care to modify are modified, while all other
# arguments are "passed through" to the next scope
{
  modules ? [ ],
  ...
}@args:

let
  filteredAttrs = builtins.removeAttrs args [ "modules" ];
in

coreRepo (
  {
    modules = modules ++ [ pkgsModule ];
    # corepkgs meta checker rejects valid keys (maintainers, teams); disable until fixed
    config.checkMeta = false;
  }
  // filteredAttrs
)
