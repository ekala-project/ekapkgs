# System-wide aprx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aprx;
in

{
  options.programs.aprx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aprx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aprx;
      description = "aprx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
