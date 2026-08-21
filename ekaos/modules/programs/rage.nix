# System-wide rage configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rage;
in

{
  options.programs.rage = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rage system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rage;
      description = "rage package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
