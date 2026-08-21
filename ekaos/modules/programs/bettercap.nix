# System-wide bettercap configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bettercap;
in

{
  options.programs.bettercap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bettercap system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bettercap;
      description = "bettercap package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
