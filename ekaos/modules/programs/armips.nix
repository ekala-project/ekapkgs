# System-wide armips configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.armips;
in

{
  options.programs.armips = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install armips system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.armips;
      description = "armips package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
