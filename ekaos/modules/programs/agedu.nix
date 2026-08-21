# System-wide agedu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.agedu;
in

{
  options.programs.agedu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install agedu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.agedu;
      description = "agedu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
