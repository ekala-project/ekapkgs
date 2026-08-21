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

  lightdmConf = ''
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
        default = pkgs.lightdm-gtk-greeter or pkgs.lightdm;
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
      description = "Extra lines appended to the [Seat:*] section.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.xserver.enable;
        message = "services.xserver.displayManager.lightdm requires services.xserver.enable = true.";
      }
    ];

    services.xserver.enable = mkDefault true;

    environment.etc."lightdm/lightdm.conf" = {
      text = lightdmConf;
      mode = "0644";
    };

    security.pam.services.lightdm = {
      text = ''
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
        auth      required    pam_env.so
        auth      sufficient  pam_permit.so
        account   required    pam_permit.so
        password  required    pam_deny.so
        session   required    pam_unix.so
        session   optional    pam_systemd.so
      '';
    };

    users.users.lightdm = {
      isSystemUser = true;
      home = "/var/lib/lightdm";
      group = "lightdm";
      description = "LightDM display manager user";
    };
    users.groups.lightdm = { };

    environment.systemPackages = [
      cfg.package
      cfg.greeter.package
    ];

    system.activationScripts.lightdm = stringAfter [ "etc" "users" ] ''
      mkdir -p /var/lib/lightdm /var/log/lightdm /var/cache/lightdm
      chown lightdm:lightdm /var/lib/lightdm /var/log/lightdm /var/cache/lightdm
      chmod 750 /var/lib/lightdm /var/log/lightdm /var/cache/lightdm
    '';
  };
}
