# System-wide betterleaks configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.betterleaks;
in

{
  options.programs.betterleaks = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install betterleaks system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.betterleaks;
      description = "betterleaks package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
