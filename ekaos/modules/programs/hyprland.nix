# Hyprland — dynamic tiling Wayland compositor
#
# This module installs and configures Hyprland system-wide, including:
# - Security wrapper for SCHED_RR capabilities
# - XDG desktop portal integration
# - XWayland support (optional)
# - Wayland session prerequisites (polkit, dconf, swaylock PAM)
# - Display manager session registration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprland;

  # Apply overrides only when the package supports them
  genFinalPackage =
    pkg: args:
    let
      expectedArgs = naturalSort (attrNames args);
      existingArgs = naturalSort (intersectLists expectedArgs (attrNames (functionArgs pkg.override)));
    in
    if existingArgs != expectedArgs then pkg else pkg.override args;
in

{
  options.programs.hyprland = {
    enable = mkEnableOption ''
      Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
      You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.
      See <https://wiki.hyprland.org> for more information'';

    package = mkOption {
      type = types.package;
      default = genFinalPackage pkgs.hyprland {
        enableXWayland = cfg.xwayland.enable;
      };
      description = ''
        Hyprland package to use.

        If the package supports `enableXWayland`, it will be overridden
        to match the {option}`xwayland.enable` option.
      '';
    };

    portalPackage = mkOption {
      type = types.package;
      default = pkgs.xdg-desktop-portal-hyprland;
      description = ''
        xdg-desktop-portal-hyprland package to use for screen sharing
        and other desktop integration features.
      '';
    };

    xwayland = {
      enable = mkEnableOption "XWayland support for running X11 applications" // {
        default = true;
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra Hyprland configuration written to /etc/xdg/hypr/hyprland.conf.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        systemPackages = [ cfg.package ];

        # Allow lua stub file and session desktop files to be found
        pathsToLink = [
          "/share/hypr"
          "/share/wayland-sessions"
        ];

        sessionVariables = {
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
        };
      };

      # Hyprland needs cap_sys_nice to set SCHED_RR on startup
      security.wrappers.Hyprland = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = "${cfg.package}/bin/Hyprland";
      };

      # XDG portal integration
      xdg.portal = {
        enable = true;
        extraPortals = [ cfg.portalPackage ];
        configPackages = mkDefault [ cfg.package ];
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
      };

      # Wayland session prerequisites
      programs.xwayland.enable = mkIf cfg.xwayland.enable (mkDefault true);

      # PAM service for swaylock compatibility
      security.pam.services.swaylock = { };
    }

    # Extra hyprland config file
    (mkIf (cfg.extraConfig != "") {
      environment.etc."xdg/hypr/hyprland.conf".text = cfg.extraConfig;
    })
  ]);
}
