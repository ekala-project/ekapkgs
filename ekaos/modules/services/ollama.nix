# Ollama AI model runner service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.ollama;
in

{
  options.services.ollama = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Ollama AI model runner.";
    };

    description = mkOption {
      type = types.str;
      default = "Ollama AI Model Runner";
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
      default = "ollama";
      description = "User to run Ollama as.";
    };

    group = mkOption {
      type = types.str;
      default = "ollama";
      description = "Group to run Ollama as.";
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
      default = pkgs.ollama;
      description = "Ollama package to use.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/ollama";
      description = "Data directory for Ollama models and state.";
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Host address for Ollama to listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 11434;
      description = "Port for Ollama API to listen on.";
    };

    environmentVariables = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        OLLAMA_NUM_PARALLEL = "2";
        OLLAMA_MAX_LOADED_MODELS = "1";
      };
      description = ''
        Extra environment variables for the Ollama service.
        Useful for GPU configuration and tuning parameters.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the Ollama API port.";
    };
  };

  config = mkIf cfg.enable {
    # Define the Ollama service
    services.ollama = {
      command = "${cfg.package}/bin/ollama";
      args = [ "serve" ];
      restartPolicy = "always";

      environment = {
        OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
        OLLAMA_MODELS = "${cfg.dataDir}/models";
      } // cfg.environmentVariables;

      ports.api = {
        port = cfg.port;
        protocol = "tcp";
        transport = "http";
        internal = cfg.host == "127.0.0.1";
        openFirewall = cfg.openFirewall;
      };

      systemd = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    # Create ollama user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.dataDir;
      group = cfg.group;
      description = "Ollama AI model runner user";
      extraGroups = [ "video" ];
    };
    users.groups.${cfg.group} = { };

    # Install ollama CLI
    environment.systemPackages = [ cfg.package ];

    # Initialize data directory
    system.activationScripts.ollama = stringAfter [ "etc" "users" ] ''
      mkdir -p ${cfg.dataDir}/models
      chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      chmod 700 ${cfg.dataDir}
    '';
  };
}
