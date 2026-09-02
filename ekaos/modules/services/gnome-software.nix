# GNOME Software — package manager for GNOME
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.gnome-software = {
    enable = mkEnableOption "GNOME Software, package manager for GNOME";
  };

  config = mkIf config.services.gnome.gnome-software.enable {
    environment.systemPackages = [ pkgs.gnome-software ];

    systemd.packages = [ pkgs.gnome-software ];
  };
}
