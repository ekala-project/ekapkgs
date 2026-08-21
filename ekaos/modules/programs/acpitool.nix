# System-wide acpitool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.acpitool;
in

{
  options.programs.acpitool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install acpitool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.acpitool;
      description = "acpitool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
