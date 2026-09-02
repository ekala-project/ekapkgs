# Hyprland compositor session service
#
# Provides a graphical session target for Hyprland, registers the session
# with display managers, and configures systemd user services.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.hyprland;
  hyprlandPkg = config.programs.hyprland.package;
in

{
  options.services.hyprland = {
    enable = mkEnableOption "Hyprland as a graphical compositor session";
  };

  config = mkIf cfg.enable {
    # Wire to programs.hyprland
    programs.hyprland.enable = mkDefault true;

    # Install the Wayland session desktop file for display managers (greetd, lightdm)
    environment.etc."wayland-sessions/hyprland.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Hyprland
        Comment=Dynamic tiling Wayland compositor
        Exec=${hyprlandPkg}/bin/Hyprland
        Type=Application
        DesktopNames=Hyprland
      '';
      mode = "0644";
    };

    # systemd user target for Hyprland session
    # Other user services (hypridle, etc.) bind to this
    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    # Ensure graphical.target is the default
    systemd.defaultUnit = mkDefault "graphical.target";

    # PAM configuration for Hyprland session
    security.pam.services.hyprland = { };

    # D-Bus environment propagation
    # Hyprland must export WAYLAND_DISPLAY etc. into systemd and D-Bus
    environment.etc."hypr/hyprland.conf.d/nixos-session.conf" = {
      text = ''
        # NixOS session integration — propagate environment to systemd/dbus
        exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP
      '';
      mode = "0644";
    };

    # Symlink wayland-sessions for display managers
    system.activationScripts.hyprland-sessions = stringAfter [ "etc" ] ''
      mkdir -p /usr/share/wayland-sessions
      ln -sf /etc/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/hyprland.desktop 2>/dev/null || true
    '';
  };
}
