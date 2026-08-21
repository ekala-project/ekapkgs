# System-wide xplr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xplr;
in

{
  options.programs.xplr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xplr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xplr;
      description = "xplr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
