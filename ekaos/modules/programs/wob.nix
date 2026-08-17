# System-wide wob configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wob;
in

{
  options.programs.wob = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wob system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wob;
      description = "wob package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
