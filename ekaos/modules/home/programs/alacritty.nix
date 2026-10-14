# Per-user Alacritty configuration
#
# Extends home.users.<name> with Alacritty options.
# Generates ~/.config/alacritty/alacritty.toml from settings.
#
# Usage:
#   home.users.alice.programs.alacritty = {
#     enable = true;
#     settings = {
#       font.size = 12;
#       window.opacity = 0.95;
#       colors.primary.background = "#1d1f21";
#     };
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

  settingsFormat = pkgs.formats.toml { };

  alacrittyOpts =
    { config, ... }:
    let
      cfg = config.programs.alacritty;
    in
    {
      options.programs.alacritty = {
        enable = mkEnableOption "per-user Alacritty configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.alacritty;
          description = "Alacritty package to install.";
        };

        settings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          example = literalExpression ''
            {
              font.size = 12;
              window.opacity = 0.95;
            }
          '';
          description = "Configuration written as TOML to ~/.config/alacritty/alacritty.toml.";
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];
        file.".config/alacritty/alacritty.toml" = mkIf (cfg.settings != { }) {
          source = settingsFormat.generate "alacritty.toml" cfg.settings;
        };
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule alacrittyOpts);
  };
}
