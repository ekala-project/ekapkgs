# GNOME Settings Daemon service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gnome-settings-daemon;
in

{
  options.services.gnome.gnome-settings-daemon = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable GNOME Settings Daemon.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gnome-settings-daemon
    ];

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    systemd.packages = [
      pkgs.gnome-settings-daemon
    ];

    systemd.user.targets."gnome-session-x11-services".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];

    systemd.user.targets."gnome-session-x11-services-ready".wants = [
      "org.gnome.SettingsDaemon.XSettings.service"
    ];
  };
}
