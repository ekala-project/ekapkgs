# System-wide units configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.units;
in

{
  options.programs.units = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install units system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.units;
      description = "units package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
