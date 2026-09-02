# Hyprlock — GPU-accelerated screen locking utility for Hyprland
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprlock;
in

{
  options.programs.hyprlock = {
    enable = mkEnableOption "hyprlock, Hyprland's GPU-accelerated screen locking utility";

    package = mkOption {
      type = types.package;
      default = pkgs.hyprlock;
      description = "hyprlock package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra hyprlock configuration written to /etc/xdg/hypr/hyprlock.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Hyprlock needs PAM access to authenticate
    security.pam.services.hyprlock = { };

    # Enable hypridle so hyprlock can detect idle time
    services.hypridle.enable = mkDefault true;

    environment.etc."xdg/hypr/hyprlock.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
