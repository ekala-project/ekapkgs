# System-wide archimedes configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.archimedes;
in

{
  options.programs.archimedes = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install archimedes system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.archimedes;
      description = "archimedes package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
