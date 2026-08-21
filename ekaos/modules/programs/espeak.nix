# System-wide espeak configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.espeak;
in

{
  options.programs.espeak = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install espeak system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.espeak;
      description = "espeak package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
