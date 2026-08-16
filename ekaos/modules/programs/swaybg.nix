# System-wide swaybg configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.swaybg;
in

{
  options.programs.swaybg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install swaybg system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.swaybg;
      description = "swaybg package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
