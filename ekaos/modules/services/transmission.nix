# Transmission BitTorrent daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.transmission;

  # Render settings to JSON for settings.json
  settingsFile = pkgs.writeText "settings.json" (
    builtins.toJSON (
      {
        # Directories
        download-dir = "${cfg.home}/Downloads";
        incomplete-dir = "${cfg.home}/.incomplete";
        incomplete-dir-enabled = true;

        # RPC / web interface
        rpc-enabled = true;
        rpc-bind-address = "0.0.0.0";
        rpc-port = cfg.settings.rpcPort;
        rpc-whitelist-enabled = cfg.settings.rpcWhitelistEnabled;
        rpc-whitelist = cfg.settings.rpcWhitelist;
        rpc-host-whitelist-enabled = false;

        # Peer settings
        peer-port = cfg.settings.peerPort;
        peer-port-random-on-start = false;

        # Protocol
        dht-enabled = true;
        pex-enabled = true;
        utp-enabled = true;
        encryption = 1;
      }
      // cfg.settings.extraSettings
    )
  );

in

{
  options.services.transmission = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Transmission BitTorrent daemon.";
    };

    description = mkOption {
      type = types.str;
      default = "Transmission BitTorrent Daemon";
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
      default = "transmission";
      description = "User to run Transmission as.";
    };

    group = mkOption {
      type = types.str;
      default = "transmission";
      description = "Group to run Transmission as.";
    };

    restartPolicy = mkOption {
      type = types.str;
      default = "always";
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

    preStart = mkOption {
      type = types.lines;
      default = "";
      description = "Shell commands to run before starting the daemon.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.transmission;
      description = "Transmission package to use.";
    };

    home = mkOption {
      type = types.str;
      default = "/var/lib/transmission";
      description = "Home/data directory for Transmission.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the peer port in the firewall.";
    };

    settings = mkOption {
      type = types.submodule {
        options = {
          peerPort = mkOption {
            type = types.port;
            default = 51413;
            description = "Port for BitTorrent peer connections.";
          };

          rpcPort = mkOption {
            type = types.port;
            default = 9091;
            description = "Port for the RPC/web interface.";
          };

          rpcWhitelistEnabled = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to enable RPC whitelist.";
          };

          rpcWhitelist = mkOption {
            type = types.str;
            default = "127.0.0.1,::1";
            description = "Comma-separated list of IP addresses allowed to access RPC.";
          };

          extraSettings = mkOption {
            type = types.attrsOf types.anything;
            default = { };
            description = ''
              Additional settings merged into settings.json.
              These override the defaults set by this module.
              See https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md
            '';
          };
        };
      };
      default = { };
      description = "Transmission configuration.";
    };
  };

  config = mkIf cfg.enable {
    # Define the Transmission service
    services.transmission = {
      command = "${cfg.package}/bin/transmission-daemon";
      args = [
        "--foreground"
        "--config-dir"
        cfg.home
      ];
      restartPolicy = "always";

      # Port contracts
      ports = {
        rpc = {
          port = cfg.settings.rpcPort;
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
            path = null;
            interval = 30;
          };
        };
        peer-tcp = {
          port = cfg.settings.peerPort;
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
        peer-udp = {
          port = cfg.settings.peerPort;
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

      environment = {
        TRANSMISSION_HOME = cfg.home;
      };

      # Systemd-specific options
      systemd = {
        after = [
          "network.target"
          "local-fs.target"
        ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    # Create transmission user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.home;
      group = cfg.group;
      description = "Transmission BitTorrent daemon user";
    };
    users.groups.${cfg.group} = { };

    # Add transmission CLI tools to system packages
    environment.systemPackages = [ cfg.package ];

    # Initialize directories and write settings.json
    system.activationScripts.transmission = stringAfter [ "etc" "users" ] ''
      # Create home and download directories
      mkdir -p ${cfg.home}
      mkdir -p ${cfg.home}/Downloads
      mkdir -p ${cfg.home}/.incomplete

      # Write settings.json (transmission reads this on startup)
      cp ${settingsFile} ${cfg.home}/settings.json
      chown -R ${cfg.user}:${cfg.group} ${cfg.home}
      chmod 750 ${cfg.home}
      chmod 640 ${cfg.home}/settings.json
    '';
  };
}
