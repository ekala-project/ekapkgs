# System-wide aces-container configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aces-container;
in

{
  options.programs.aces-container = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aces-container system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aces-container;
      description = "aces-container package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
