# GLib Networking — network extensions for GLib
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.glib-networking;
in

{
  options.services.gnome.glib-networking = {
    enable = mkEnableOption "network extensions for GLib";
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.glib-networking ];

    systemd.packages = [ pkgs.glib-networking ];

    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];
  };
}
