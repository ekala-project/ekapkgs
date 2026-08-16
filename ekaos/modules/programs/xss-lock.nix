# System-wide xss-lock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xss-lock;
in

{
  options.programs.xss-lock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xss-lock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xss-lock;
      description = "xss-lock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
