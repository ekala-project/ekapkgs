# System-wide dateutils configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dateutils;
in

{
  options.programs.dateutils = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dateutils system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dateutils;
      description = "dateutils package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
