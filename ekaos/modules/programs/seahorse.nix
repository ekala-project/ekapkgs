# Seahorse — GNOME encryption key and password manager
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.seahorse;
in

{
  options.programs.seahorse = {
    enable = mkEnableOption "Seahorse, a GNOME application for managing encryption keys and passwords";

    package = mkOption {
      type = types.package;
      default = pkgs.seahorse;
      description = "Seahorse package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];
  };
}
