let
  pins = import ./pins.nix;

  lib = import pins.lib;

  coreRepo = import pins.core;
in

# Continuation passing style of import
# Values we care to modify are modified, while all other
# arguments are "passed through" to the next scope
{ modules ? [], ... }@args:

let
  filteredAttrs = builtins.removeAttrs args [ "modules" ];
in

coreRepo ({
  modules = modules ++ [ (import ./pkgs-module.nix) ];
} // filteredAttrs)
