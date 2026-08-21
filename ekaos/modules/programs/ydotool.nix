# System-wide ydotool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ydotool;
  runtimeDirectory = "ydotoold";
  socketPath = "/run/${runtimeDirectory}/socket";
in

{
  options = {
    programs.ydotool = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable ydotoold service and ydotool.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ydotool;
        description = "ydotool package to use.";
      };

      group = mkOption {
        type = types.str;
        default = "ydotool";
        description = "Group which users must be in to use ydotool.";
      };
    };

    services.ydotoold = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the ydotoold service.";
      };

      description = mkOption {
        type = types.str;
        default = "ydotoold - backend for ydotool";
        description = "Service description.";
      };

      command = mkOption {
        type = types.str;
        internal = true;
        description = "Command to run.";
      };

      args = mkOption {
        type = types.listOf types.str;
        internal = true;
        default = [ ];
        description = "Command arguments.";
      };

      user = mkOption {
        type = types.str;
        default = "root";
        description = "User to run service as.";
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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.YDOTOOL_SOCKET = socketPath;

    users.groups.${cfg.group} = { };

    services.ydotoold = {
      enable = true;
      command = "${cfg.package}/bin/ydotoold";
      args = [
        "--socket-path=${socketPath}"
        "--socket-perm=0660"
      ];
      restartPolicy = "always";
      systemd = {
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    system.activationScripts.ydotoold = stringAfter [ "etc" ] ''
      mkdir -p /run/${runtimeDirectory}
      chmod 0750 /run/${runtimeDirectory}
      ${optionalString (cfg.group != "") "chgrp ${cfg.group} /run/${runtimeDirectory} || true"}
    '';
  };
}
