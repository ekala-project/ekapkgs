# Per-user foot terminal configuration
#
# Extends home.users.<name> with foot-specific options.
# Generates ~/.config/foot/foot.ini from settings using INI format.
#
# Usage:
#   home.users.alice.programs.foot = {
#     enable = true;
#     settings = {
#       main = {
#         font = "JetBrains Mono:size=12";
#         dpi-aware = "yes";
#         pad = "4x4";
#       };
#       scrollback = {
#         lines = 10000;
#       };
#       colors = {
#         background = "282828";
#         foreground = "ebdbb2";
#       };
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

  footOpts =
    { config, ... }:
    let
      cfg = config.programs.foot;

      settingsFormat = pkgs.formats.ini { };
      configFile = settingsFormat.generate "foot.ini" cfg.settings;
    in
    {
      options.programs.foot = {
        enable = mkEnableOption "per-user foot terminal configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.foot;
          description = "Foot package to install.";
        };

        settings = mkOption {
          type = types.attrsOf (types.attrsOf types.anything);
          default = { };
          example = literalExpression ''
            {
              main = {
                font = "JetBrains Mono:size=12";
                dpi-aware = "yes";
              };
              scrollback = {
                lines = 10000;
              };
              colors = {
                background = "282828";
                foreground = "ebdbb2";
              };
            }
          '';
          description = ''
            Foot configuration as nested attribute sets.
            Top-level keys are INI section names.
            Generated using pkgs.formats.ini.
          '';
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];

        file.".config/foot/foot.ini".source = configFile;
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule footOpts);
  };
}
