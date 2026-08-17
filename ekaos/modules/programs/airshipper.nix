# System-wide airshipper configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.airshipper;
in

{
  options.programs.airshipper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install airshipper system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.airshipper;
      description = "airshipper package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
