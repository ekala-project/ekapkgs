# System-wide sway-launcher-desktop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sway-launcher-desktop;
in

{
  options.programs.sway-launcher-desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sway-launcher-desktop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sway-launcher-desktop;
      description = "sway-launcher-desktop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
