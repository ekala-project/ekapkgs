# PackageKit — D-Bus package management abstraction
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.packagekit;
in

{
  options.services.packagekit = {
    enable = mkEnableOption "PackageKit, a D-Bus package management daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.packagekit;
      description = "PackageKit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    security.polkit.enable = true;
  };
}
