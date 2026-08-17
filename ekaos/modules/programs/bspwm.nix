# System-wide bspwm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bspwm;
in

{
  options.programs.bspwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bspwm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bspwm;
      description = "bspwm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
