# System-wide reflex configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.reflex;
in

{
  options.programs.reflex = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install reflex system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.reflex;
      description = "reflex package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
