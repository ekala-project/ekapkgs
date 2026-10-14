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

    group = mkOption {
      type = types.str;
      default = "docker";
      description = "Group for Docker socket access.";
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
