# input-remapper — input device remapping daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.input-remapper;
in

{
  options.services.input-remapper = {
    enable = mkEnableOption "input-remapper, a daemon for remapping input devices";

    package = mkOption {
      type = types.package;
      default = pkgs.input-remapper;
      description = "input-remapper package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.services.input-remapper = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
