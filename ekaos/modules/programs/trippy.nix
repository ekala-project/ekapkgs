# System-wide trippy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.trippy;
in

{
  options.programs.trippy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install trippy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.trippy;
      description = "trippy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
