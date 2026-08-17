# System-wide dnsproxy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dnsproxy;
in

{
  options.programs.dnsproxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dnsproxy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dnsproxy;
      description = "dnsproxy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
