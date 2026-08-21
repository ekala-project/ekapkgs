# System-wide tcptraceroute configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tcptraceroute;
in

{
  options.programs.tcptraceroute = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tcptraceroute system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tcptraceroute;
      description = "tcptraceroute package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
