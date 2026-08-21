# System-wide traceroute configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.traceroute;
in

{
  options.programs.traceroute = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install traceroute system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.traceroute;
      description = "traceroute package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
