# System-wide astroterm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.astroterm;
in

{
  options.programs.astroterm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install astroterm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.astroterm;
      description = "astroterm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
