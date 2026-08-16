# System-wide restic backup configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.restic;
in

{
  options.programs.restic = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install restic system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.restic;
      description = "restic package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
