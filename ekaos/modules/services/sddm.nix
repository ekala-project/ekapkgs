# SDDM — Simple Desktop Display Manager
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.sddm;
in

{
  options.services.sddm = {
    enable = mkEnableOption "SDDM, the Simple Desktop Display Manager";

    package = mkOption {
      type = types.package;
      default = pkgs.sddm;
      description = "SDDM package to use.";
    };

    wayland.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to run SDDM under Wayland.";
    };

    theme = mkOption {
      type = types.str;
      default = "";
      description = "Theme to use for the SDDM login screen.";
    };

    autoNumlock = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Num Lock at login.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra SDDM configuration appended to sddm.conf.";
    };

    settings = mkOption {
      type = types.attrsOf (types.attrsOf types.anything);
      default = { };
      description = ''
        SDDM configuration as a nested attribute set.
        Keys are INI sections, values are key-value pairs.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Provide the wayland-sessions directory for session discovery
    environment.pathsToLink = [
      "/share/wayland-sessions"
      "/share/xsessions"
    ];

    # SDDM systemd service
    systemd.services.sddm = {
      description = "SDDM Display Manager";
      after = [
        "systemd-user-sessions.service"
        "getty@tty1.service"
        "plymouth-quit.service"
      ];
      conflicts = [ "getty@tty1.service" ];
      wantedBy = [ "graphical.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sddm";
        Restart = "always";
      };

      environment = mkMerge [
        (mkIf (cfg.theme != "") { SDDM_THEME = cfg.theme; })
      ];
    };

    # Graphical target as default
    systemd.defaultUnit = mkDefault "graphical.target";

    # PAM service for SDDM
    security.pam.services.sddm = { };
    security.pam.services.sddm-greeter = { };
    security.pam.services.sddm-autologin = { };
  };
}
