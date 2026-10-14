# openfortivpn — Fortinet VPN client
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.openfortivpn;
in

{
  options.programs.openfortivpn = {
    enable = mkEnableOption "openfortivpn, a Fortinet SSL VPN client";

    package = mkOption {
      type = types.package;
      default = pkgs.openfortivpn;
      description = "openfortivpn package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
