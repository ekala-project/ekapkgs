# System-wide wev configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wev;
in

{
  options.programs.wev = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wev system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wev;
      description = "wev package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
