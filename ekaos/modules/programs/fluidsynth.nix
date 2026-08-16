# System-wide fluidsynth configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fluidsynth;
in

{
  options.programs.fluidsynth = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fluidsynth system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fluidsynth;
      description = "fluidsynth package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
