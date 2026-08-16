# System-wide sl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sl;
in

{
  options.programs.sl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sl;
      description = "sl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
