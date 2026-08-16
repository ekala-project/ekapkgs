# System-wide wtype configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wtype;
in

{
  options.programs.wtype = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wtype system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wtype;
      description = "wtype package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
