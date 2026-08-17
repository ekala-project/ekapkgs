# System-wide stress-ng configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stress-ng;
in

{
  options.programs.stress-ng = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stress-ng system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stress-ng;
      description = "stress-ng package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
