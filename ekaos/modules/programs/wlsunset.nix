# System-wide wlsunset configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wlsunset;
in

{
  options.programs.wlsunset = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wlsunset system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wlsunset;
      description = "wlsunset package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
