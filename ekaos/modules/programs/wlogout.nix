# System-wide wlogout configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wlogout;
in

{
  options.programs.wlogout = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wlogout system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wlogout;
      description = "wlogout package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
