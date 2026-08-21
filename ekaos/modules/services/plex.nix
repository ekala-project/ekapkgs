# Plex Media Server service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.plex;
in

{
  options.services.plex = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Plex Media Server.";
    };

    description = mkOption {
      type = types.str;
      default = "Plex Media Server";
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
      default = "plex";
      description = "User to run Plex as.";
    };

    group = mkOption {
      type = types.str;
      default = "plex";
      description = "Group to run Plex as.";
    };

    environment = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Environment variables (set automatically).";
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

    package = mkOption {
      type = types.package;
      default = pkgs.plex;
      description = "Plex Media Server package to use.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/plex";
      description = "Data directory for Plex configuration and metadata.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open firewall ports for Plex.

        Opens TCP ports 32400, 3005, 8324, 32469 and
        UDP ports 1900, 32410-32414 for network discovery
        and DLNA.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Define the Plex service
    services.plex = {
      command = "${cfg.package}/bin/plexmediaserver";
      args = [ ];
      restartPolicy = "always";

      environment = {
        PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR = cfg.dataDir;
      };

      ports = {
        web = {
          port = 32400;
          protocol = "tcp";
          transport = "http";
          internal = false;
          openFirewall = cfg.openFirewall;
        };
      } // optionalAttrs cfg.openFirewall {
        companion = {
          port = 3005;
          protocol = "tcp";
          transport = "tcp";
          internal = false;
          openFirewall = true;
        };
        roku = {
          port = 8324;
          protocol = "tcp";
          transport = "tcp";
          internal = false;
          openFirewall = true;
        };
        dlna-tcp = {
          port = 32469;
          protocol = "tcp";
          transport = "tcp";
          internal = false;
          openFirewall = true;
        };
        dlna-udp = {
          port = 1900;
          protocol = "udp";
          transport = "udp";
          internal = false;
          openFirewall = true;
        };
        gdm1 = {
          port = 32410;
          protocol = "udp";
          transport = "udp";
          internal = false;
          openFirewall = true;
        };
        gdm2 = {
          port = 32412;
          protocol = "udp";
          transport = "udp";
          internal = false;
          openFirewall = true;
        };
        gdm3 = {
          port = 32413;
          protocol = "udp";
          transport = "udp";
          internal = false;
          openFirewall = true;
        };
        gdm4 = {
          port = 32414;
          protocol = "udp";
          transport = "udp";
          internal = false;
          openFirewall = true;
        };
      };

      systemd = {
        after = [
          "network.target"
          "local-fs.target"
        ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    # Create plex user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.dataDir;
      group = cfg.group;
      description = "Plex Media Server user";
    };
    users.groups.${cfg.group} = { };

    # Install plex package
    environment.systemPackages = [ cfg.package ];

    # Initialize data directory
    system.activationScripts.plex = stringAfter [ "etc" "users" ] ''
      mkdir -p ${cfg.dataDir}
      chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      chmod 700 ${cfg.dataDir}
    '';
  };
}
