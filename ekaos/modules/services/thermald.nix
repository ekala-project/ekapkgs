# thermald — thermal management daemon for Intel systems
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.thermald;
in

{
  options.services.thermald = {
    enable = mkEnableOption "thermald, a thermal management daemon for Intel CPUs";

    package = mkOption {
      type = types.package;
      default = pkgs.thermald;
      description = "thermald package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.thermald = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
