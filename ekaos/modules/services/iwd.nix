# iwd — iNet Wireless Daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.iwd;
in

{
  options.services.iwd = {
    enable = mkEnableOption "iwd, a wireless daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.iwd;
      description = "iwd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.iwd = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
