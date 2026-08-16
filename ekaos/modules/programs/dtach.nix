# System-wide dtach configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dtach;
in

{
  options.programs.dtach = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dtach system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dtach;
      description = "dtach package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
