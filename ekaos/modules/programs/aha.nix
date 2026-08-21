# System-wide aha configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aha;
in

{
  options.programs.aha = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aha system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aha;
      description = "aha package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
