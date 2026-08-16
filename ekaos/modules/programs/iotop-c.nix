# System-wide iotop-c configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.iotop-c;
in

{
  options.programs.iotop-c = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install iotop-c system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.iotop-c;
      description = "iotop-c package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
