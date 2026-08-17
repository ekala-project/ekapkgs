# System-wide i3lock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.i3lock;
in

{
  options.programs.i3lock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable i3lock screen locker.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.i3lock;
      description = "i3lock package to use.";
    };

    u2fSupport = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable U2F support. Adds a setuid wrapper and PAM service.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.i3lock = mkIf cfg.u2fSupport {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package.out}/bin/i3lock";
    };

    security.pam.services.i3lock = mkIf cfg.u2fSupport { };
  };
}
