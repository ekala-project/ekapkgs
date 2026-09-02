# System-wide hyprpaper configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprpaper;
in

{
  options.programs.hyprpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hyprpaper system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hyprpaper;
      description = "hyprpaper package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra hyprpaper configuration content written to /etc/xdg/hypr/hyprpaper.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/hypr/hyprpaper.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
