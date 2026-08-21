# System-wide exercism configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.exercism;
in

{
  options.programs.exercism = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install exercism system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.exercism;
      description = "exercism package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
