# System-wide scooter configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.scooter;
in

{
  options.programs.scooter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install scooter system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.scooter;
      description = "scooter package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
