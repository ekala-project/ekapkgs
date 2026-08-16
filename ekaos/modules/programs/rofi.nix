# System-wide rofi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rofi;
in

{
  options.programs.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rofi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rofi;
      description = "rofi package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/rofi/config.rasi.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."rofi/config.rasi" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
