# System-wide man-db configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.man-db;
in

{
  options.programs.man-db = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install man-db system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.man-db;
      description = "man-db package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
