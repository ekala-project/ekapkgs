# System-wide ahcpd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ahcpd;
in

{
  options.programs.ahcpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ahcpd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ahcpd;
      description = "ahcpd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
