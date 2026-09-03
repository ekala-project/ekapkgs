# Syncthing — continuous file synchronization
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.syncthing;
in

{
  options.services.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Syncthing continuous file synchronization service.";
    };

    description = mkOption {
      type = types.str;
      default = "Syncthing — Continuous File Synchronization";
      description = "Service description.";
    };

    command = mkOption {
      type = types.str;
      internal = true;
      description = "Command to run (set automatically).";
    };

    args = mkOption {
      type = types.listOf types.str;
      internal = true;
      default = [ ];
      description = "Command arguments (set automatically).";
    };

    user = mkOption {
      type = types.str;
      description = "User to run Syncthing as.";
    };

    group = mkOption {
      type = types.str;
      default = "syncthing";
      description = "Group to run Syncthing as.";
    };

    restartPolicy = mkOption {
      type = types.str;
      default = "on-failure";
      description = "Restart policy.";
    };

    systemd = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Systemd-specific options.";
    };

    ports = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Port contracts for this service.";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables for the service.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.syncthing;
      description = "Syncthing package to use.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/syncthing";
      description = "Default sync folder path.";
    };

    configDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/.config/syncthing";
      defaultText = literalExpression ''"''${cfg.dataDir}/.config/syncthing"'';
      description = "Syncthing configuration directory.";
    };

    guiAddress = mkOption {
      type = types.str;
      default = "127.0.0.1:8384";
      description = "Address and port for the Syncthing web GUI.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for Syncthing sync and discovery ports.";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      command = "${cfg.package}/bin/syncthing";
      args = [
        "serve"
        "--no-browser"
        "--no-restart"
        "--config=${cfg.configDir}"
        "--data=${cfg.dataDir}"
        "--gui-address=${cfg.guiAddress}"
      ];
      restartPolicy = "on-failure";

      environment = {
        STNORESTART = "1";
        HOME = cfg.dataDir;
      };

      ports = {
        gui = {
          port = 8384;
          protocol = "tcp";
          transport = "http";
          hostname = null;
          path = "/";
          internal = true;
          openFirewall = false;
          tls = {
            enable = false;
            forceRedirect = true;
            acme = false;
          };
          healthCheck = {
            path = "/rest/noauth/health";
            interval = 30;
          };
        };
        sync = {
          port = 22000;
          protocol = "tcp";
          transport = "tcp";
          hostname = null;
          path = "/";
          internal = false;
          openFirewall = cfg.openFirewall;
          tls = {
            enable = false;
            forceRedirect = true;
            acme = false;
          };
          healthCheck = {
            path = null;
            interval = 30;
          };
        };
        discovery = {
          port = 21027;
          protocol = "udp";
          transport = "udp";
          hostname = null;
          path = "/";
          internal = false;
          openFirewall = cfg.openFirewall;
          tls = {
            enable = false;
            forceRedirect = true;
            acme = false;
          };
          healthCheck = {
            path = null;
            interval = 30;
          };
        };
      };

      systemd = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.dataDir;
      group = cfg.group;
      description = "Syncthing file synchronization user";
    };
    users.groups.${cfg.group} = { };

    environment.systemPackages = [ cfg.package ];

    system.activationScripts.syncthing = stringAfter [ "etc" "users" ] ''
      mkdir -p ${cfg.configDir}
      chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      chmod 700 ${cfg.dataDir}
    '';
  };
}
