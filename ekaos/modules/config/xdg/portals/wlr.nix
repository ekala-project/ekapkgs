# xdg-desktop-portal-wlr configuration
#
# Configures the wlroots portal backend for screen sharing, screenshots,
# and other desktop integration features on wlroots-based compositors.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.xdg.portal.wlr;
  package = pkgs.xdg-desktop-portal-wlr;
in

{
  options.xdg.portal.wlr = {
    enable = mkEnableOption ''
      desktop portal for wlroots-based desktops.

      This adds xdg-desktop-portal-wlr to the portal packages'';

    settings = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = literalExpression ''
        {
          screencast = {
            output_name = "HDMI-A-1";
            max_fps = "30";
            chooser_type = "simple";
          };
        }
      '';
      description = ''
        Configuration for xdg-desktop-portal-wlr.
        See xdg-desktop-portal-wlr(5) for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ package ];
    };

    environment.etc = mkIf (cfg.settings != { }) {
      "xdg/xdg-desktop-portal-wlr/config".text = generators.toINI { } cfg.settings;
    };
  };
}
