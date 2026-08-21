# System-wide fpp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fpp;
in

{
  options.programs.fpp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fpp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fpp;
      description = "fpp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
