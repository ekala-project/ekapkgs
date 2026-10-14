# blueman — GTK Bluetooth manager
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.blueman;
in

{
  options.services.blueman = {
    enable = mkEnableOption "Blueman, a GTK Bluetooth manager";

    package = mkOption {
      type = types.package;
      default = pkgs.blueman;
      description = "Blueman package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.blueman-mechanism = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
