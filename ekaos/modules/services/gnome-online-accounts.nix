# GNOME Online Accounts daemon service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gnome-online-accounts;
in

{
  options.services.gnome.gnome-online-accounts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable GNOME Online Accounts daemon, a service that
        provides a single sign-on framework for the GNOME desktop.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome-online-accounts ];

    # TODO: services.dbus.packages = [ pkgs.gnome-online-accounts ];
  };
}
