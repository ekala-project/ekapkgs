# System-wide arp-scan configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.arp-scan;
in

{
  options.programs.arp-scan = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install arp-scan system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.arp-scan;
      description = "arp-scan package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
