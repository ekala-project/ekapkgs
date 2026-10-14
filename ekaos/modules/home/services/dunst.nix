# Per-user dunst notification daemon
#
# Extends home.users.<name> with dunst options.
# Generates ~/.config/dunst/dunstrc and a systemd user unit
# for the notification daemon (D-Bus activated).
#
# Usage:
#   home.users.alice.services.dunst = {
#     enable = true;
#     settings = {
#       global = {
#         font = "Monospace 10";
#         geometry = "300x5-30+20";
#         transparency = 10;
#         frame_color = "#eceff1";
#       };
#       urgency_low = {
#         background = "#263238";
#         foreground = "#8be9fd";
#         timeout = 5;
#       };
#       urgency_normal = {
#         background = "#263238";
#         foreground = "#f8f8f2";
#         timeout = 10;
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
    optionalString
    literalExpression
    ;

  dunstOpts =
    { config, ... }:
    let
      cfg = config.services.dunst;

      iniFormat = pkgs.formats.ini { };

      dunstrcContent =
        lib.generators.toINI { } cfg.settings
        + optionalString (cfg.extraConfig != "") "\n${cfg.extraConfig}";
    in
    {
      options.services.dunst = {
        enable = mkEnableOption "dunst notification daemon";

        package = mkOption {
          type = types.package;
          default = pkgs.dunst;
          defaultText = literalExpression "pkgs.dunst";
          description = "The dunst package to use.";
        };

        settings = mkOption {
          type = iniFormat.type;
          default = { };
          description = ''
            Configuration for dunst in INI format.
            Each top-level attribute is a section name, and its value is
            an attribute set of key-value pairs within that section.
            See dunst(5) for available options.
          '';
          example = literalExpression ''
            {
              global = {
                font = "Monospace 10";
                frame_color = "#eceff1";
              };
              urgency_normal = {
                background = "#263238";
                foreground = "#f8f8f2";
                timeout = 10;
              };
            }
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Additional lines appended to dunstrc.";
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];

        file.".config/dunst/dunstrc".text = dunstrcContent;

        file.".config/systemd/user/dunst.service".text = ''
          [Unit]
          Description=Dunst notification daemon
          Documentation=man:dunst(1)
          After=graphical-session.target
          PartOf=graphical-session.target

          [Service]
          Type=dbus
          BusName=org.freedesktop.Notifications
          ExecStart=${cfg.package}/bin/dunst
          Restart=on-failure

          [Install]
          WantedBy=graphical-session.target
        '';
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule dunstOpts);
  };
}
