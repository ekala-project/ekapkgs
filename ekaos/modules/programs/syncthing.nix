# System-wide Syncthing configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.syncthing;
in

{
  options.programs.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Syncthing system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.syncthing;
      description = "Syncthing package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
