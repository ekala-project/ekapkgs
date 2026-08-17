# System-wide AVRDUDE configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.avrdude;
in

{
  options.programs.avrdude = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install AVRDUDE system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.avrdude;
      description = "AVRDUDE package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
