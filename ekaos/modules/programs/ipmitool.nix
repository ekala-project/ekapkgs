# System-wide ipmitool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ipmitool;
in

{
  options.programs.ipmitool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ipmitool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ipmitool;
      description = "ipmitool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
