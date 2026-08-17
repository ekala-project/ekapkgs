# System-wide async-profiler configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.async-profiler;
in

{
  options.programs.async-profiler = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install async-profiler system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.async-profiler;
      description = "async-profiler package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
