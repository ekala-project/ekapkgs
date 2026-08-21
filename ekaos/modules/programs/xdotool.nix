# System-wide xdotool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xdotool;
in

{
  options.programs.xdotool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xdotool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xdotool;
      description = "xdotool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
