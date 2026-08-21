# System-wide usbutils configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.usbutils;
in

{
  options.programs.usbutils = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install usbutils system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.usbutils;
      description = "usbutils package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
