# System-wide watchdog configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.watchdog;
in

{
  options.programs.watchdog = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install watchdog system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.watchdog;
      description = "watchdog package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
