# gpsd — GPS service daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gpsd;
in

{
  options.services.gpsd = {
    enable = mkEnableOption "gpsd, a GPS service daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.gpsd;
      description = "gpsd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    users.users.gpsd = {
      isSystemUser = true;
      group = "dialout";
      description = "gpsd daemon user";
    };
  };
}
