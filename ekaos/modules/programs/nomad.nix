# System-wide Nomad configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nomad;
in

{
  options.programs.nomad = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nomad system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nomad;
      description = "nomad package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
