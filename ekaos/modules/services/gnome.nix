# GNOME Desktop Environment
#
# Orchestrates all GNOME services, shell components, and default applications.
# Modelled after nixpkgs services/desktop-managers/gnome.nix but adapted for EkaOS.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.desktopManager.gnome;
  serviceCfg = config.services.gnome;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };
in

{
  options = {

    services.gnome = {
      core-os-services.enable = mkEnableOption "essential system services for GNOME";
      core-shell.enable = mkEnableOption "GNOME Shell services";
      core-apps.enable = mkEnableOption "GNOME core applications";
    };

    services.desktopManager.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the GNOME desktop environment.";
      };

      sessionPath = mkOption {
        default = [ ];
        type = types.listOf types.package;
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.
        '';
      };

      debug = mkEnableOption "GNOME session debug messages";
    };

    environment.gnome.excludePackages = mkOption {
      default = [ ];
      type = types.listOf types.package;
      description = "Which packages GNOME should exclude from the default environment.";
    };

  };

  config = mkMerge [
    # ── Main toggle ──────────────────────────────────────────────────────
    (mkIf cfg.enable {
      services.gnome.core-os-services.enable = true;
      services.gnome.core-shell.enable = true;
      services.gnome.core-apps.enable = mkDefault true;

      # Register GNOME wayland session for display managers
      environment.etc."wayland-sessions/gnome.desktop" = {
        text = ''
          [Desktop Entry]
          Name=GNOME
          Comment=GNOME Desktop Environment
          Exec=${pkgs.gnome-session}/bin/gnome-session
          Type=Application
          DesktopNames=GNOME
        '';
        mode = "0644";
      };

      # Symlink for display managers that look in /usr/share
      system.activationScripts.gnome-sessions = stringAfter [ "etc" ] ''
        mkdir -p /usr/share/wayland-sessions
        ln -sf /etc/wayland-sessions/gnome.desktop /usr/share/wayland-sessions/gnome.desktop 2>/dev/null || true
      '';

      # Session path: add gsettings schemas and GI typelib paths
      environment.systemPackages = cfg.sessionPath;

      environment.sessionVariables = mkMerge [
        (mkIf cfg.debug { GNOME_SESSION_DEBUG = "1"; })
      ];

      # Ensure graphical.target is the default
      systemd.defaultUnit = mkDefault "graphical.target";
    })

    # ── Core OS services ─────────────────────────────────────────────────
    (mkIf serviceCfg.core-os-services.enable {
      # Required services
      services.gnome.at-spi2-core.enable = true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.gnome-keyring.enable = mkDefault true;
      services.gnome.gcr-ssh-agent.enable = mkDefault true;
      services.gnome.gnome-online-accounts.enable = mkDefault true;
      services.gnome.tinysparql.enable = mkDefault true;
      services.gnome.localsearch.enable = mkDefault true;
      services.accounts-daemon.enable = true;

      # Security
      security.polkit.enable = true;
      security.rtkit.enable = mkDefault true;

      # XDG standards
      xdg.mime.enable = true;
      xdg.icons.enable = true;
      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      xdg.portal.configPackages = mkDefault [ pkgs.gnome-session ];

      # Networking
      networking.networkmanager.enable = mkDefault true;

      # Sound theme
      environment.systemPackages = [
        pkgs.sound-theme-freedesktop
      ];

      # Needed for themes and backgrounds
      environment.pathsToLink = [
        "/share"
      ];
    })

    # ── Core Shell ───────────────────────────────────────────────────────
    (mkIf serviceCfg.core-shell.enable {
      services.desktopManager.gnome.sessionPath = [
        pkgs.gnome-shell
      ];

      # Shell services
      services.colord.enable = mkDefault true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-browser-connector.enable = mkDefault true;
      services.gnome.gnome-initial-setup.enable = mkDefault true;
      services.gnome.gnome-remote-desktop.enable = mkDefault true;
      services.gnome.gnome-settings-daemon.enable = true;
      services.gnome.gnome-user-share.enable = mkDefault true;
      services.gvfs.enable = true;

      systemd.packages = [
        pkgs.gnome-session
        pkgs.gnome-shell
      ];

      # Restarting this unit terminates the active GNOME session
      systemd.user.services.gnome-session-monitor = {
        restartIfChanged = false;
      };

      # Mutter udev rules for KMS modifier forcing
      services.udev.packages = [ pkgs.mutter ];

      # Default fonts
      fonts.packages = [
        pkgs.adwaita-fonts
      ];

      # Shell packages
      environment.systemPackages = [
        pkgs.gnome-shell
        pkgs.adwaita-icon-theme
        pkgs.gnome-backgrounds
        pkgs.gnome-bluetooth
        pkgs.gnome-color-manager
        pkgs.gnome-control-center
        pkgs.gnome-tour
        pkgs.gnome-user-docs
        pkgs.glib # for gsettings program
        pkgs.gnome-menus
        pkgs.xdg-user-dirs
        pkgs.xdg-user-dirs-gtk
      ];
    })

    # ── Core Apps ────────────────────────────────────────────────────────
    (mkIf serviceCfg.core-apps.enable {
      environment.systemPackages = [
        pkgs.baobab
        pkgs.gnome-text-editor
        pkgs.gnome-calculator
        pkgs.gnome-calendar
        pkgs.gnome-characters
        pkgs.gnome-clocks
        pkgs.gnome-console
        pkgs.gnome-contacts
        pkgs.gnome-font-viewer
        pkgs.gnome-logs
        pkgs.gnome-maps
        pkgs.gnome-music
        pkgs.gnome-system-monitor
        pkgs.gnome-tecla
        pkgs.gnome-weather
        pkgs.nautilus
        pkgs.papers
        pkgs.gnome-connections
        pkgs.simple-scan
        pkgs.snapshot
        pkgs.yelp
      ];

      services.gnome.sushi.enable = mkDefault true;

      # Nautilus extension discovery
      environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

      # Default mime handler for directories
      environment.sessionVariables.XDG_DATA_DIRS = [ "${mimeAppsList}/share" ];

      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
      ];
    })
  ];
}
