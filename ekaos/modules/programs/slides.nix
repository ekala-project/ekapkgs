# System-wide slides configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.slides;
in

{
  options.programs.slides = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install slides system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.slides;
      description = "slides package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
