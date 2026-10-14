# Per-user udiskie automount daemon
#
# Extends home.users.<name> with udiskie options.
# Generates ~/.config/udiskie/config.yml and a systemd user unit
# for automatic removable media mounting.
#
# Usage:
#   home.users.alice.services.udiskie = {
#     enable = true;
#     tray = "always";
#     notify = true;
#     automount = true;
#     settings = {
#       program_options = {
#         file_manager = "thunar";
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
    concatStringsSep
    optional
    literalExpression
    ;

  udiskieOpts =
    { config, ... }:
    let
      cfg = config.services.udiskie;

      yamlFormat = pkgs.formats.yaml { };

      configFile = yamlFormat.generate "udiskie-config.yml" cfg.settings;

      # Build command-line flags
      commandArgs = concatStringsSep " " (
        [ "${cfg.package}/bin/udiskie" ]
        ++ [
          "--tray"
          cfg.tray
        ]
        ++ optional (!cfg.notify) "--no-notify"
        ++ optional (!cfg.automount) "--no-automount"
      );
    in
    {
      options.services.udiskie = {
        enable = mkEnableOption "udiskie automount daemon";

        package = mkOption {
          type = types.package;
          default = pkgs.udiskie;
          defaultText = literalExpression "pkgs.udiskie";
          description = "The udiskie package to use.";
        };

        tray = mkOption {
          type = types.enum [
            "auto"
            "always"
            "never"
          ];
          default = "auto";
          description = ''
            Whether to show the tray icon.
            "auto" shows the icon only when a device is connected.
            "always" always shows the icon.
            "never" disables the tray icon entirely.
          '';
        };

        notify = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to show desktop notifications on mount/unmount events.";
        };

        automount = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to automatically mount new devices.";
        };

        settings = mkOption {
          type = yamlFormat.type;
          default = { };
          description = ''
            Configuration for udiskie in YAML format.
            Written to ~/.config/udiskie/config.yml.
            See udiskie(8) for available options.
          '';
          example = literalExpression ''
            {
              program_options = {
                file_manager = "thunar";
              };
            }
          '';
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];

        file.".config/udiskie/config.yml".source = configFile;

        file.".config/systemd/user/udiskie.service".text = ''
          [Unit]
          Description=udiskie automount daemon
          Documentation=man:udiskie(8)
          After=graphical-session.target
          PartOf=graphical-session.target

          [Service]
          Type=simple
          ExecStart=${commandArgs}
          Restart=on-failure

          [Install]
          WantedBy=graphical-session.target
        '';
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule udiskieOpts);
  };
}
