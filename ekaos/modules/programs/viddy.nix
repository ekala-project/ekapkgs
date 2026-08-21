# System-wide viddy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.viddy;
in

{
  options.programs.viddy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install viddy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.viddy;
      description = "viddy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
