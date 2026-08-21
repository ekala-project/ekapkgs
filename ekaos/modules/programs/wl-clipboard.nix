# System-wide wl-clipboard configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wl-clipboard;
in

{
  options.programs.wl-clipboard = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wl-clipboard system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wl-clipboard;
      description = "wl-clipboard package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
