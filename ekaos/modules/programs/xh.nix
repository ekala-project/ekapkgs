# System-wide xh configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xh;
in

{
  options.programs.xh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xh system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xh;
      description = "xh package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
