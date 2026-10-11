# autorandr — automatic display configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autorandr;
in

{
  options.programs.autorandr = {
    enable = mkEnableOption "autorandr, an automatic display configuration tool";

    package = mkOption {
      type = types.package;
      default = pkgs.autorandr;
      description = "autorandr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];
  };
}
