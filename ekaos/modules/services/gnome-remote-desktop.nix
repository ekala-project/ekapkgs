# GNOME Remote Desktop service (using Pipewire)
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gnome-remote-desktop;
in

{
  options.services.gnome.gnome-remote-desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Remote Desktop support using Pipewire.";
    };
  };

  config = mkIf cfg.enable {
    services.pipewire.enable = true;
    services.dbus.packages = [ pkgs.gnome-remote-desktop ];
    security.polkit.enable = true;

    environment.systemPackages = [ pkgs.gnome-remote-desktop ];

    systemd.packages = [ pkgs.gnome-remote-desktop ];
    systemd.tmpfiles.packages = [ pkgs.gnome-remote-desktop ];

    users.users.gnome-remote-desktop = {
      isSystemUser = true;
      group = "gnome-remote-desktop";
      home = "/var/lib/gnome-remote-desktop";
      description = "GNOME Remote Desktop user";
    };
    users.groups.gnome-remote-desktop = { };
  };
}
