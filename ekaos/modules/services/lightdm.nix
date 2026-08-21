# LightDM display manager service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.displayManager.lightdm;

  # Generate lightdm.conf
  lightdmConf = pkgs.writeText "lightdm.conf" ''
    [LightDM]
    minimum-vt=7

    [Seat:*]
    xserver-command=${pkgs.xorg.xorgserver}/bin/X
    greeter-session=${cfg.greeter.name}
    ${cfg.extraSeatDefaults}

    ${cfg.extraConfig}
  '';

in

{
  options.services.xserver.displayManager.lightdm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the LightDM display manager.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lightdm;
      description = "LightDM package to use.";
    };

    greeter = {
      package = mkOption {
        type = types.package;
        default = pkgs.lightdm-gtk-greeter;
        description = "Greeter package to use with LightDM.";
      };

      name = mkOption {
        type = types.str;
        default = "lightdm-gtk-greeter";
        description = "Name of the greeter session to use.";
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines appended to lightdm.conf.";
    };

    extraSeatDefaults = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines appended to the [Seat:*] section of lightdm.conf.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.xserver.enable;
        message = "services.xserver.displayManager.lightdm requires services.xserver.enable = true.";
      }
    ];

    # Implicitly enable the X server when LightDM is enabled
    services.xserver.enable = mkDefault true;

    # Register lightdm as a service contract
    services.lightdm = {
      enable = true;
      description = "LightDM Display Manager";
      command = "${cfg.package}/bin/lightdm";
      args = [ "--config" "/etc/lightdm/lightdm.conf" ];
      user = "root";
      restartPolicy = "always";

      systemd = {
        after = [ "systemd-udev-settle.service" "getty@tty7.service" ];
        wantedBy = [ "graphical.target" ];
        serviceConfig = {
          Type = "simple";
        };
      };
    };

    # Write lightdm.conf
    environment.etc."lightdm/lightdm.conf" = {
      text = builtins.readFile lightdmConf;
      mode = "0644";
    };

    # PAM configuration for lightdm
    security.pam.services.lightdm = {
      text = ''
        # PAM configuration for lightdm
        auth      required    pam_env.so
        auth      required    pam_unix.so nullok
        auth      required    pam_deny.so

        account   required    pam_unix.so
        account   required    pam_nologin.so

        password  required    pam_unix.so sha512 shadow

        session   required    pam_unix.so
        session   required    pam_limits.so
        session   optional    pam_systemd.so
        session   optional    pam_loginuid.so
      '';
    };

    security.pam.services.lightdm-greeter = {
      text = ''
        # PAM configuration for lightdm-greeter
        auth      required    pam_env.so
        auth      sufficient  pam_permit.so

        account   required    pam_permit.so

        password  required    pam_deny.so

        session   required    pam_unix.so
        session   optional    pam_systemd.so
      '';
    };

    # Create lightdm user and group
    users.users.lightdm = {
      isSystemUser = true;
      home = "/var/lib/lightdm";
      group = "lightdm";
      description = "LightDM display manager user";
    };
    users.groups.lightdm = { };

    # Install LightDM and greeter packages
    environment.systemPackages = [
      cfg.package
      cfg.greeter.package
    ];

    # Create required directories
    system.activationScripts.lightdm = stringAfter [ "etc" "users" ] ''
      mkdir -p /var/lib/lightdm
      mkdir -p /var/log/lightdm
      mkdir -p /var/cache/lightdm

      chown lightdm:lightdm /var/lib/lightdm
      chown lightdm:lightdm /var/log/lightdm
      chown lightdm:lightdm /var/cache/lightdm

      chmod 750 /var/lib/lightdm
      chmod 750 /var/log/lightdm
      chmod 750 /var/cache/lightdm
    '';
  };
}
