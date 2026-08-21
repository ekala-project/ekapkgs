# System-wide earlyoom OOM prevention
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.earlyoom;
in

{
  options.programs.earlyoom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install earlyoom system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.earlyoom;
      description = "earlyoom package to use.";
    };

    freeMemThreshold = mkOption {
      type = types.int;
      default = 10;
      description = "Minimum free memory percentage before earlyoom takes action.";
    };

    freeSwapThreshold = mkOption {
      type = types.int;
      default = 10;
      description = "Minimum free swap percentage before earlyoom takes action.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command-line arguments to pass to earlyoom.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
