# Per-user XDG base directory configuration
#
# Extends home.users.<name> with XDG base directory setup.
# Sets XDG_* environment variables and optionally creates the
# directories via an activation script.
#
# Usage:
#   home.users.alice.programs.xdg = {
#     enable = true;
#     cacheHome = "$HOME/.cache";
#     configHome = "$HOME/.config";
#     dataHome = "$HOME/.local/share";
#     stateHome = "$HOME/.local/state";
#   };
{ lib, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    ;

  xdgOpts =
    { config, ... }:
    let
      cfg = config.programs.xdg;
    in
    {
      options.programs.xdg = {
        enable = mkEnableOption "per-user XDG base directory setup";

        cacheHome = mkOption {
          type = types.str;
          default = "$HOME/.cache";
          description = "XDG_CACHE_HOME directory.";
        };

        configHome = mkOption {
          type = types.str;
          default = "$HOME/.config";
          description = "XDG_CONFIG_HOME directory.";
        };

        dataHome = mkOption {
          type = types.str;
          default = "$HOME/.local/share";
          description = "XDG_DATA_HOME directory.";
        };

        stateHome = mkOption {
          type = types.str;
          default = "$HOME/.local/state";
          description = "XDG_STATE_HOME directory.";
        };

        createDirectories = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create the XDG directories during activation.";
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          sessionVariables = {
            XDG_CACHE_HOME = cfg.cacheHome;
            XDG_CONFIG_HOME = cfg.configHome;
            XDG_DATA_HOME = cfg.dataHome;
            XDG_STATE_HOME = cfg.stateHome;
          };
        }

        (mkIf cfg.createDirectories {
          activation.xdgDirs = {
            deps = [ ];
            text = ''
              mkdir -p ${cfg.cacheHome}
              mkdir -p ${cfg.configHome}
              mkdir -p ${cfg.dataHome}
              mkdir -p ${cfg.stateHome}
            '';
          };
        })
      ]);
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule xdgOpts);
  };
}
