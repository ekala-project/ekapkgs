# System-wide usbtop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.usbtop;
in

{
  options.programs.usbtop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable usbtop with the usbmon kernel module.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.usbtop;
      description = "usbtop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    boot.kernelModules = [ "usbmon" ];
  };
}
