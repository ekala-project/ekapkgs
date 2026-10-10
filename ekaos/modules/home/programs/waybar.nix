# Per-user Waybar configuration
#
# Extends home.users.<name> with Waybar options.
# Generates ~/.config/waybar/config.jsonc and ~/.config/waybar/style.css.
#
# Usage:
#   home.users.alice.programs.waybar = {
#     enable = true;
#     settings = [{
#       layer = "top";
#       modules-left = [ "sway/workspaces" ];
#       modules-right = [ "clock" "battery" ];
#     }];
#     style = ''
#       * { font-family: monospace; font-size: 13px; }
#     '';
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    literalExpression
    ;

  waybarOpts =
    { config, ... }:
    let
      cfg = config.programs.waybar;
    in
    {
      options.programs.waybar = {
        enable = mkEnableOption "per-user Waybar configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.waybar;
          description = "Waybar package to install.";
        };

        settings = mkOption {
          type = types.anything;
          default = { };
          example = literalExpression ''
            [{
              layer = "top";
              modules-left = [ "sway/workspaces" ];
              modules-right = [ "clock" "battery" ];
            }]
          '';
          description = ''
            Waybar configuration. Can be a single bar config (attrset)
            or a list of bar configs. Written as JSON to
            ~/.config/waybar/config.jsonc.
          '';
        };

        style = mkOption {
          type = types.lines;
          default = "";
          description = "CSS stylesheet written to ~/.config/waybar/style.css.";
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          packages = [ cfg.package ];
        }

        (mkIf (cfg.settings != { } && cfg.settings != [ ]) {
          file.".config/waybar/config.jsonc".text =
            builtins.toJSON cfg.settings;
        })

        (mkIf (cfg.style != "") {
          file.".config/waybar/style.css".text = cfg.style;
        })
      ]);
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule waybarOpts);
  };
}
