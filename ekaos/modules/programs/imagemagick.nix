# System-wide imagemagick configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.imagemagick;
in

{
  options.programs.imagemagick = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install imagemagick system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.imagemagick;
      description = "imagemagick package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
