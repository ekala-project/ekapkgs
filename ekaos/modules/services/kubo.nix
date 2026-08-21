# Kubo (IPFS) daemon service
# Provides a local IPFS node for content-addressed storage
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.kubo;

  # Generate IPFS config overrides as JSON
  settingsJson = pkgs.writeText "ipfs-config-overrides.json" (builtins.toJSON cfg.settings);

  # Build daemon args
  daemonArgs =
    [ "daemon" ]
    ++ optional cfg.autoMount "--mount";

in

{
  options = {
    services.kubo = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Kubo IPFS daemon.

          Kubo is the reference implementation of IPFS (InterPlanetary File System),
          providing content-addressed, peer-to-peer hypermedia distribution.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.kubo;
        description = "The Kubo package to use.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/ipfs";
        description = ''
          Path to the IPFS data directory.

          This is where the IPFS repository (blocks, config, datastore) is stored.
        '';
      };

      autoMount = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to mount /ipfs and /ipns via FUSE.

          Requires FUSE support in the kernel.
        '';
      };

      settings = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        example = literalExpression ''
          {
            Gateway.HTTPHeaders."Access-Control-Allow-Origin" = [ "*" ];
            Swarm.ConnMgr = {
              LowWater = 50;
              HighWater = 300;
            };
          }
        '';
        description = ''
          IPFS configuration overrides.

          These are applied on top of the default IPFS configuration
          via `ipfs config replace` after initialization.
          See https://github.com/ipfs/kubo/blob/master/docs/config.md
          for available options.
        '';
      };

      defaultMode = mkOption {
        type = types.str;
        default = "online";
        description = ''
          Default IPFS daemon mode.

          Common values: "online", "offline", "norouting".
        '';
      };

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = "User account under which Kubo runs.";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = "Group under which Kubo runs.";
      };

      description = mkOption {
        type = types.str;
        default = "Kubo IPFS Daemon";
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

      restartPolicy = mkOption {
        type = types.str;
        default = "always";
        description = "Restart policy.";
      };

      environment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        internal = true;
        description = "Environment variables (set automatically).";
      };

      preStart = mkOption {
        type = types.str;
        default = "";
        internal = true;
        description = "Pre-start script (set automatically).";
      };

      workingDirectory = mkOption {
        type = types.nullOr types.str;
        default = null;
        internal = true;
        description = "Working directory for the service.";
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
    };
  };

  config = mkIf cfg.enable {
    # Create ipfs user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      description = "IPFS daemon user";
    };

    users.groups.${cfg.group} = { };

    # Set the service contract fields
    services.kubo = {
      command = "${cfg.package}/bin/ipfs";
      args = daemonArgs;
      workingDirectory = cfg.dataDir;

      environment = {
        IPFS_PATH = cfg.dataDir;
      };

      # Pre-start: initialize repo if needed, apply config overrides
      preStart = ''
        export IPFS_PATH="${cfg.dataDir}"
        ipfs="${cfg.package}/bin/ipfs"

        # Initialize IPFS repo if it doesn't exist
        if [ ! -f "$IPFS_PATH/config" ]; then
          $ipfs init
        fi

        # Apply config overrides if any are set
        ${optionalString (cfg.settings != { }) ''
          # Merge user settings into existing config
          existing="$(cat "$IPFS_PATH/config")"
          merged="$(echo "$existing" | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' - ${settingsJson})"
          echo "$merged" > "$IPFS_PATH/config"
        ''}

        ${optionalString cfg.autoMount ''
          # Create FUSE mount points
          mkdir -p /ipfs /ipns
        ''}
      '';

      # Port contracts
      ports = {
        swarm = {
          port = 4001;
          protocol = "tcp";
          transport = "tcp";
          hostname = null;
          path = "/";
          internal = false;
          openFirewall = true;
          tls = { enable = false; forceRedirect = true; acme = false; };
          healthCheck = { path = null; interval = 30; };
        };

        gateway = {
          port = 8080;
          protocol = "tcp";
          transport = "http";
          hostname = null;
          path = "/";
          internal = false;
          openFirewall = true;
          tls = { enable = false; forceRedirect = true; acme = false; };
          healthCheck = { path = null; interval = 30; };
        };

        api = {
          port = 5001;
          protocol = "tcp";
          transport = "http";
          hostname = null;
          path = "/";
          internal = true;
          openFirewall = true;
          tls = { enable = false; forceRedirect = true; acme = false; };
          healthCheck = { path = null; interval = 30; };
        };
      };

      # Systemd-specific configuration
      systemd = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          # Hardening
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ReadWritePaths = [ cfg.dataDir ] ++ optionals cfg.autoMount [ "/ipfs" "/ipns" ];
        };
      };
    };

    # Add kubo to system packages so ipfs CLI is available
    environment.systemPackages = [ cfg.package ];

    # Create data directory and set permissions via activation script
    system.activationScripts.kubo = stringAfter [ "etc" "users" ] ''
      # Create IPFS data directory
      mkdir -p "${cfg.dataDir}"
      chown -R ${cfg.user}:${cfg.group} "${cfg.dataDir}"
      chmod 750 "${cfg.dataDir}"
    '';
  };
}
