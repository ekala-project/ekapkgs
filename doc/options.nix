# Evaluate ekapkgs-contributed ekaos modules and produce options.json
#
# Usage: nix-build doc/options.nix
# Output: result/options.json
{
  system ? "x86_64-linux",
}:

let
  pkgs = import ../. { inherit system; };
  # Patch lib.filesystem to include isPath (missing in current nix-lib)
  lib = pkgs.lib.extend (
    final: prev: {
      filesystem = prev.filesystem // {
        isPath = prev.filesystem.isPath or builtins.isPath;
      };
      isPath = prev.isPath or builtins.isPath;
    }
  );

  ekapkgsModuleList = import ../ekaos/modules/module-list.nix;
  ekapkgsModules = builtins.filter builtins.pathExists ekapkgsModuleList;

  eval = lib.evalModules {
    modules = ekapkgsModules ++ [
      { config._module.check = false; }
    ];
    specialArgs = {
      inherit lib pkgs;
      modulesPath = ../ekaos/modules;
    };
  };

  rawOpts = lib.optionAttrSetToDocList eval.options;
  filteredOpts = builtins.filter (opt: opt.visible && !opt.internal) rawOpts;

  root = toString ./..;

  cleanDecl =
    decl:
    let
      declStr = toString decl;
    in
    if lib.hasPrefix root declStr then
      let
        subpath = lib.removePrefix "/" (lib.removePrefix root declStr);
      in
      {
        url = "https://github.com/ekala-project/ekapkgs/blob/master/${subpath}";
        name = subpath;
      }
    else
      {
        url = "";
        name = declStr;
      };

  optionsNix = builtins.listToAttrs (
    map (o: {
      name = o.name;
      value =
        removeAttrs o [
          "name"
          "visible"
          "internal"
        ]
        // {
          declarations = map cleanDecl o.declarations;
        };
    }) filteredOpts
  );
in
pkgs.runCommand "ekaos-options-json"
  {
    passAsFile = [ "options" ];
    options = builtins.unsafeDiscardStringContext (builtins.toJSON optionsNix);
  }
  ''
    mkdir -p $out
    cp "$optionsPath" $out/options.json
  ''
