# System-wide ansilove configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ansilove;
in

{
  options.programs.ansilove = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ansilove system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ansilove;
      description = "ansilove package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
