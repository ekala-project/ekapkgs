# System-wide alsa-oss configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.alsa-oss;
in

{
  options.programs.alsa-oss = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install alsa-oss system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.alsa-oss;
      description = "alsa-oss package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
