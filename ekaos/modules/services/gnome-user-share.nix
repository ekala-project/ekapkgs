# GNOME User Share — user-level file sharing service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.gnome-user-share = {
    enable = mkEnableOption "GNOME User Share, a user-level file sharing service for GNOME";
  };

  config = mkIf config.services.gnome.gnome-user-share.enable {
    environment.systemPackages = [ pkgs.gnome-user-share ];

    systemd.packages = [ pkgs.gnome-user-share ];
  };
}
