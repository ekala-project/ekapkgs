# GNOME Keyring daemon service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gnome-keyring;
in

{
  options.services.gnome.gnome-keyring = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable GNOME Keyring daemon, a service designed to
        take care of the user's security credentials, such as user names
        and passwords.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome-keyring ];

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];
    xdg.portal.extraPortals = [ pkgs.gnome-keyring ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon";
    };
  };
}
