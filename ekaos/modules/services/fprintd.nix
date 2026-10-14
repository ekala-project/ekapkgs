# fprintd — fingerprint authentication daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.fprintd;
in

{
  options.services.fprintd = {
    enable = mkEnableOption "fprintd, a D-Bus daemon for fingerprint reader access";

    package = mkOption {
      type = types.package;
      default = pkgs.fprintd;
      description = "fprintd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
