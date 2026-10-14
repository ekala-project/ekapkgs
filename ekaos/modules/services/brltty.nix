# brltty — braille display access daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.brltty;
in

{
  options.services.brltty = {
    enable = mkEnableOption "brltty, a braille display access daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.brltty;
      description = "brltty package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];
  };
}
