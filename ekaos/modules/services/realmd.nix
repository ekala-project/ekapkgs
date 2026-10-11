# realmd — realm discovery and enrollment daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.realmd;
in

{
  options.services.realmd = {
    enable = mkEnableOption "realmd, a D-Bus daemon for Active Directory/Kerberos realm management";

    package = mkOption {
      type = types.package;
      default = pkgs.realmd;
      description = "realmd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };
}
