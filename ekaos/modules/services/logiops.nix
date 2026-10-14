# logiops — Logitech HID++ device daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.logiops;
in

{
  options.services.logiops = {
    enable = mkEnableOption "logiops, a userspace daemon for Logitech HID++ devices";

    package = mkOption {
      type = types.package;
      default = pkgs.logiops;
      description = "logiops package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.logid = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
