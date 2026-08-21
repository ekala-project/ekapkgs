# System-wide miller configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.miller;
in

{
  options.programs.miller = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install miller system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.miller;
      description = "miller package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
