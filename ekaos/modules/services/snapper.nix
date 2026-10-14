# snapper — filesystem snapshot management
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.snapper;
in

{
  options.services.snapper = {
    enable = mkEnableOption "snapper, a filesystem snapshot management tool";

    package = mkOption {
      type = types.package;
      default = pkgs.snapper;
      description = "snapper package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
