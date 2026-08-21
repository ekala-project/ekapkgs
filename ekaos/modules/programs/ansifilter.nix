# System-wide ansifilter configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ansifilter;
in

{
  options.programs.ansifilter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ansifilter system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ansifilter;
      description = "ansifilter package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
