# wpa_supplicant — WPA/WPA2/IEEE 802.1X authentication
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.wpa_supplicant;
in

{
  options.services.wpa_supplicant = {
    enable = mkEnableOption "wpa_supplicant, a WPA/WPA2 authentication daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.wpa_supplicant;
      description = "wpa_supplicant package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
