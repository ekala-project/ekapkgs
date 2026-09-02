# GNOME Initial Setup — first-run configuration wizard
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.gnome-initial-setup = {
    enable = mkEnableOption "GNOME Initial Setup, a simple, easy, and safe way to prepare a new system";
  };

  config = mkIf config.services.gnome.gnome-initial-setup.enable {
    environment.systemPackages = [ pkgs.gnome-initial-setup ];

    systemd.packages = [ pkgs.gnome-initial-setup ];

    systemd.user.targets."gnome-session".wants = [
      "gnome-initial-setup-first-login.service"
    ];

    systemd.user.targets."graphical-session-pre".wants = [
      "gnome-initial-setup-copy-worker.service"
    ];

    systemd.user.targets."gnome-session@gnome-initial-setup".wants = [
      "gnome-initial-setup.service"
    ];

    users.groups.gnome-initial-setup = { };
  };
}
