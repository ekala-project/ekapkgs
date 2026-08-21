# System-wide spectrwm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.spectrwm;
in

{
  options.programs.spectrwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install spectrwm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.spectrwm;
      description = "spectrwm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
