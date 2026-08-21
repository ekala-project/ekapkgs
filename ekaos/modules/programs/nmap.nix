# System-wide nmap configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nmap;
in

{
  options.programs.nmap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nmap system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nmap;
      description = "nmap package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
