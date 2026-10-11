# geoclue2 — geolocation framework
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.geoclue2;
in

{
  options.services.geoclue2 = {
    enable = mkEnableOption "GeoClue2, a D-Bus geolocation service";

    package = mkOption {
      type = types.package;
      default = pkgs.geoclue2;
      description = "GeoClue2 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    users.users.geoclue = {
      isSystemUser = true;
      group = "geoclue";
      description = "GeoClue2 daemon user";
    };

    users.groups.geoclue = { };
  };
}
