# System-wide tty-clock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tty-clock;
in

{
  options.programs.tty-clock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tty-clock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tty-clock;
      description = "tty-clock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
