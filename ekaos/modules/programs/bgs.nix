# System-wide bgs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bgs;
in

{
  options.programs.bgs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bgs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bgs;
      description = "bgs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
