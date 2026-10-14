# xfconf — Xfce configuration storage system
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xfconf;
in

{
  options.programs.xfconf = {
    enable = mkEnableOption "xfconf, the Xfce configuration storage backend";

    package = mkOption {
      type = types.package;
      default = pkgs.xfconf;
      description = "xfconf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];
  };
}
