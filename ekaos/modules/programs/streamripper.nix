# System-wide streamripper configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.streamripper;
in

{
  options.programs.streamripper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install streamripper system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.streamripper;
      description = "streamripper package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
