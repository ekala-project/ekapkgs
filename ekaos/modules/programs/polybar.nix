# System-wide Polybar configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.polybar;
in

{
  options.programs.polybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Polybar system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.polybar;
      description = "Polybar package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/polybar/config.ini.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."polybar/config.ini" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
