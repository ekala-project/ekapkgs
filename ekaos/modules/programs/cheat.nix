# System-wide cheat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cheat;
in

{
  options.programs.cheat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cheat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cheat;
      description = "cheat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
