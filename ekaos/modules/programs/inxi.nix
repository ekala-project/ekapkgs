# System-wide inxi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.inxi;
in

{
  options.programs.inxi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install inxi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.inxi;
      description = "inxi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
