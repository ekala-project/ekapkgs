# System-wide jless configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.jless;
in

{
  options.programs.jless = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install jless system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.jless;
      description = "jless package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
