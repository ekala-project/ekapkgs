# Docker — container runtime service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.docker;
in

{
  options.services.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Docker container runtime.";
    };

    description = mkOption {
      type = types.str;
      default = "Docker Container Runtime";
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
      default = "root";
      description = "User to run Docker as.";
    };

    group = mkOption {
      type = types.str;
      default = "docker";
      description = "Group for Docker socket access.";
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

    package = mkOption {
      type = types.package;
      default = pkgs.docker;
      description = "Docker package to use.";
    };

    dataRoot = mkOption {
      type = types.str;
      default = "/var/lib/docker";
      description = "Root directory for Docker state.";
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command-line arguments for the Docker daemon.";
    };

    storageDriver = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Storage driver to use (e.g., overlay2, btrfs, zfs).";
    };

    liveRestore = mkOption {
      type = types.bool;
      default = true;
      description = "Whether containers should survive a daemon restart.";
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to periodically prune unused Docker resources.";
      };

      dates = mkOption {
        type = types.str;
        default = "weekly";
        description = "Calendar expression for auto-prune schedule.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.docker = {
      command = "${cfg.package}/bin/dockerd";
      args = [
        "--data-root"
        cfg.dataRoot
      ]
      ++ lib.optional cfg.liveRestore "--live-restore"
      ++ lib.optionals (cfg.storageDriver != null) [
        "--storage-driver"
        cfg.storageDriver
      ]
      ++ cfg.extraOptions;
      restartPolicy = "always";

      systemd = {
        after = [
          "network.target"
          "firewall.service"
        ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    # Docker group for non-root access
    users.groups.${cfg.group} = { };

    environment.systemPackages = [ cfg.package ];

    system.activationScripts.docker = stringAfter [ "etc" "users" ] ''
      mkdir -p ${cfg.dataRoot}
      chmod 710 ${cfg.dataRoot}
    '';

    # Auto-prune timer
    systemd.timers.docker-prune = mkIf cfg.autoPrune.enable {
      description = "Docker Prune Timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.autoPrune.dates;
        Persistent = true;
      };
    };

    systemd.services.docker-prune = mkIf cfg.autoPrune.enable {
      description = "Docker System Prune";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.package}/bin/docker system prune -af";
      };
    };
  };
}
