# Hypridle — Hyprland's idle daemon
#
# Runs as a systemd user service and triggers actions (lock, suspend, etc.)
# after configurable idle timeouts.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.hypridle;
in

{
  options.services.hypridle = {
    enable = mkEnableOption "hypridle, Hyprland's idle daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.hypridle;
      description = "hypridle package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra hypridle configuration written to /etc/xdg/hypr/hypridle.conf.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # systemd user service — starts with graphical session
    systemd.user.services.hypridle = {
      description = "Hyprland idle daemon";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hypridle";
        Restart = "on-failure";
        RestartSec = 5;
      };
      path = filter (p: p != null) [
        (config.programs.hyprland.package or null)
        (config.programs.hyprlock.package or null)
        pkgs.procps
      ];
    };

    environment.etc."xdg/hypr/hypridle.conf" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
