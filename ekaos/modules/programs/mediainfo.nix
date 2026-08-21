# System-wide mediainfo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mediainfo;
in

{
  options.programs.mediainfo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mediainfo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mediainfo;
      description = "mediainfo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
