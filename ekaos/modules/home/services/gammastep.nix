# Per-user gammastep screen color temperature daemon
#
# Extends home.users.<name> with gammastep options.
# Generates ~/.config/gammastep/config.ini and a systemd user unit
# for automatic screen color temperature adjustment.
#
# Usage:
#   home.users.alice.services.gammastep = {
#     enable = true;
#     temperature.day = 6500;
#     temperature.night = 3700;
#     latitude = "48.8566";
#     longitude = "2.3522";
#     enableIndicator = true;
#     settings = {
#       general = {
#         adjustment-method = "wayland";
#         fade = 1;
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

  gammastepOpts =
    { config, ... }:
    let
      cfg = config.services.gammastep;

      iniFormat = pkgs.formats.ini { };

      # Merge user settings with structured options
      mergedSettings = {
        general = {
          temp-day = cfg.temperature.day;
          temp-night = cfg.temperature.night;
          location-provider = "manual";
        }
        // (cfg.settings.general or { });

        manual = (
          { }
          // (if cfg.latitude != null then { lat = cfg.latitude; } else { })
          // (if cfg.longitude != null then { lon = cfg.longitude; } else { })
          // (cfg.settings.manual or { })
        );
      }
      // (removeAttrs cfg.settings [
        "general"
        "manual"
      ]);

      configFile = iniFormat.generate "gammastep-config.ini" mergedSettings;

      executable =
        if cfg.enableIndicator then
          "${cfg.package}/bin/gammastep-indicator"
        else
          "${cfg.package}/bin/gammastep";
    in
    {
      options.services.gammastep = {
        enable = mkEnableOption "gammastep screen color temperature daemon";

        package = mkOption {
          type = types.package;
          default = pkgs.gammastep;
          defaultText = literalExpression "pkgs.gammastep";
          description = "The gammastep package to use.";
        };

        temperature = {
          day = mkOption {
            type = types.int;
            default = 6500;
            description = "Color temperature during the day (in Kelvin).";
          };

          night = mkOption {
            type = types.int;
            default = 4500;
            description = "Color temperature during the night (in Kelvin).";
          };
        };

        latitude = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "48.8566";
          description = "Latitude for location-based color temperature (decimal degrees).";
        };

        longitude = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "2.3522";
          description = "Longitude for location-based color temperature (decimal degrees).";
        };

        enableIndicator = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to use gammastep-indicator (with system tray icon) instead of gammastep.";
        };

        settings = mkOption {
          type = iniFormat.type;
          default = { };
          description = ''
            Additional configuration for gammastep in INI format.
            Settings here are merged with the structured options (temperature,
            latitude, longitude). Section names map to INI sections.
            See gammastep(1) for available options.
          '';
          example = literalExpression ''
            {
              general = {
                adjustment-method = "wayland";
                fade = 1;
              };
            }
          '';
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];

        file.".config/gammastep/config.ini".source = configFile;

        file.".config/systemd/user/gammastep.service".text = ''
          [Unit]
          Description=Gammastep screen color temperature daemon
          Documentation=https://gitlab.com/chinstrap/gammastep
          After=graphical-session.target
          PartOf=graphical-session.target

          [Service]
          Type=simple
          ExecStart=${executable}
          Restart=on-failure
          RestartSec=3

          [Install]
          WantedBy=graphical-session.target
        '';
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule gammastepOpts);
  };
}
