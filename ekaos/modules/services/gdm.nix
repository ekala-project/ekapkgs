# GDM (GNOME Display Manager) service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.displayManager.gdm;
  gdm = pkgs.gdm;

  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "custom.conf" cfg.settings;

  pulseConfig = pkgs.writeText "default.pa" ''
    load-module module-device-restore
    load-module module-card-restore
    load-module module-udev-detect
    load-module module-native-protocol-unix
    load-module module-default-device-restore
    load-module module-always-sink
    load-module module-intended-roles
    load-module module-suspend-on-idle
    load-module module-position-event-sounds
  '';

in

{
  options.services.xserver.displayManager.gdm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable GDM, the GNOME Display Manager.";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable debugging messages in GDM.";
    };

    autoSuspend = mkOption {
      type = types.bool;
      default = true;
      description = ''
        On the GNOME Display Manager login screen, suspend the machine
        after inactivity. Does not affect automatic suspend while logged
        in or at the lock screen.
      '';
    };

    banner = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = "Optional message to display on the login screen.";
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        debug.enable = true;
      };
      description = ''
        Options passed to the gdm daemon.
        See https://help.gnome.org/admin/gdm/stable/configuration.html.en#daemonconfig
        for supported options.
      '';
    };

    autoLogin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable automatic login.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "User to automatically log in as.";
      };

      delay = mkOption {
        type = types.int;
        default = 0;
        description = "Seconds of inactivity after which the autologin will be performed.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.autoLogin.enable -> cfg.autoLogin.user != null;
        message = "services.xserver.displayManager.gdm.autoLogin.user must be set when autoLogin is enabled.";
      }
    ];

    services.xserver.displayManager.lightdm.enable = mkDefault false;

    users.users.gdm = {
      isSystemUser = true;
      group = "gdm";
      home = "/run/gdm";
      description = "GDM user";
    };
    users.groups.gdm = { };

    # GDM settings
    services.xserver.displayManager.gdm.settings = {
      daemon = mkMerge [
        (mkIf (cfg.autoLogin.enable && cfg.autoLogin.delay != 0) {
          TimedLoginEnable = true;
          TimedLogin = cfg.autoLogin.user;
          TimedLoginDelay = cfg.autoLogin.delay;
        })
        (mkIf (cfg.autoLogin.enable && cfg.autoLogin.delay == 0) {
          AutomaticLoginEnable = true;
          AutomaticLogin = cfg.autoLogin.user;
        })
      ];
      debug = mkIf cfg.debug {
        Enable = true;
      };
    };

    environment.etc."gdm/custom.conf".source = configFile;

    environment.systemPackages = [
      gdm
      pkgs.adwaita-icon-theme
    ];

    # TODO: services.dbus.packages = [ gdm ];
    # TODO: services.accounts-daemon.enable = true;
    # TODO: programs.dconf.profiles.gdm for autoSuspend and banner settings

    systemd.packages = [
      gdm
      pkgs.gnome-session
      pkgs.gnome-shell
    ];

    # The upstream gdm package ships a systemd service unit that we do not
    # use; disable it in favour of the display-manager service.
    systemd.services.gdm.enable = false;

    security.pam.services.gdm-launch-environment = {
      text = ''
        auth      required    pam_env.so
        auth      sufficient  pam_permit.so
        account   sufficient  pam_unix.so
        password  required    pam_deny.so
        session   required    pam_env.so
        session   optional    pam_systemd.so
        session   optional    pam_keyinit.so force revoke
        session   optional    pam_permit.so
      '';
    };

    security.pam.services.gdm-password = {
      text = ''
        auth      substack    login
        account   include     login
        password  substack    login
        session   include     login
      '';
    };

    security.pam.services.gdm-autologin = {
      text = ''
        auth      requisite   pam_nologin.so
        auth      required    pam_permit.so
        account   sufficient  pam_unix.so
        password  requisite   pam_unix.so nullok
        session   optional    pam_keyinit.so revoke
        session   include     login
      '';
    };

    system.activationScripts.gdm = stringAfter [ "etc" "users" ] ''
      mkdir -p /run/gdm
      chown gdm:gdm /run/gdm
      chmod 711 /run/gdm
    '';
  };
}
