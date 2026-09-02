# colord — color management daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.colord = {
    enable = mkEnableOption "colord, the color management daemon";
  };

  config = mkIf config.services.colord.enable {
    environment.systemPackages = [ pkgs.colord ];

    services.dbus.packages = [ pkgs.colord ];

    # TODO: services.udev.packages = [ pkgs.colord ];

    systemd.packages = [ pkgs.colord ];

    systemd.tmpfiles.packages = [ pkgs.colord ];

    users.users.colord = {
      isSystemUser = true;
      home = "/var/lib/colord";
      group = "colord";
    };

    users.groups.colord = { };
  };
}
