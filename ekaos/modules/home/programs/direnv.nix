# Per-user direnv configuration
#
# Extends home.users.<name> with direnv options.
# Generates ~/.config/direnv/direnvrc and bash integration.
#
# Usage:
#   home.users.alice.programs.direnv = {
#     enable = true;
#     enableBashIntegration = true;
#     config = {
#       global.warn_timeout = "30s";
#       global.hide_env_diff = true;
#     };
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    concatStringsSep
    mapAttrsToList
    literalExpression
    ;

  settingsFormat = pkgs.formats.toml { };

  direnvOpts =
    { config, ... }:
    let
      cfg = config.programs.direnv;
    in
    {
      options.programs.direnv = {
        enable = mkEnableOption "per-user direnv configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.direnv;
          description = "direnv package to install.";
        };

        enableBashIntegration = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to hook direnv into bash via programs.bash.initExtra.";
        };

        config = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          example = literalExpression ''
            {
              global.warn_timeout = "30s";
              global.hide_env_diff = true;
            }
          '';
          description = "direnv configuration written as TOML to ~/.config/direnv/direnv.toml.";
        };

        direnvrcExtra = mkOption {
          type = types.lines;
          default = "";
          description = "Extra lines appended to ~/.config/direnv/direnvrc.";
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          packages = [ cfg.package ];
        }

        (mkIf (cfg.config != { }) {
          file.".config/direnv/direnv.toml".source =
            settingsFormat.generate "direnv.toml" cfg.config;
        })

        (mkIf (cfg.direnvrcExtra != "") {
          file.".config/direnv/direnvrc".text = cfg.direnvrcExtra;
        })

        (mkIf cfg.enableBashIntegration {
          programs.bash.initExtra = ''
            eval "$(${cfg.package}/bin/direnv hook bash)"
          '';
        })
      ]);
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule direnvOpts);
  };
}
