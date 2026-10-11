# rtkit — RealtimeKit, a D-Bus daemon for real-time scheduling
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.rtkit;
in

{
  options.services.rtkit = {
    enable = mkEnableOption "rtkit, a D-Bus daemon for granting real-time scheduling priority";

    package = mkOption {
      type = types.package;
      default = pkgs.rtkit;
      description = "rtkit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    security.polkit.enable = true;
  };
}
