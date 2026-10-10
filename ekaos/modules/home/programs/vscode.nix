# Per-user VSCode configuration
#
# Extends home.users.<name> with VSCode options.
# Optionally wraps VSCode in an FHS environment with extra packages.
#
# Usage:
#   home.users.alice.programs.vscode = {
#     enable = true;
#     # Simple:
#     # package = pkgs.vscode;
#     # With FHS wrapping:
#     fhs.enable = true;
#     fhs.packages = ps: with ps; [ zlib rustup ];
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    literalExpression
    ;

  vscodeOpts =
    { config, ... }:
    let
      cfg = config.programs.vscode;

      effectivePackage =
        if cfg.fhs.enable then
          pkgs.vscode-fhsWithPackages cfg.fhs.packages
        else
          cfg.package;
    in
    {
      options.programs.vscode = {
        enable = mkEnableOption "per-user VSCode";

        package = mkOption {
          type = types.package;
          default = pkgs.vscode;
          description = "VSCode package to install (ignored when fhs.enable is true).";
        };

        fhs = {
          enable = mkEnableOption "FHS-compatible VSCode wrapper";

          packages = mkOption {
            type = types.functionTo (types.listOf types.package);
            default = _: [ ];
            example = literalExpression "ps: with ps; [ zlib rustup ]";
            description = ''
              Function from the package set to a list of packages
              available inside the FHS environment.
            '';
          };
        };
      };

      config = mkIf cfg.enable {
        packages = [ effectivePackage ];
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule vscodeOpts);
  };
}
