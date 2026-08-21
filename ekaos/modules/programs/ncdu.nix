# System-wide ncdu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ncdu;
in

{
  options.programs.ncdu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ncdu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ncdu;
      description = "ncdu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
