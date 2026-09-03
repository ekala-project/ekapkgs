# Tailscale — mesh VPN service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tailscale;
in

{
  options.services.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the Tailscale mesh VPN service.";
    };

    description = mkOption {
      type = types.str;
      default = "Tailscale Mesh VPN";
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
      description = "User to run Tailscale as.";
    };

    group = mkOption {
      type = types.str;
      default = "root";
      description = "Group to run Tailscale as.";
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
      default = pkgs.tailscale;
      description = "Tailscale package to use.";
    };

    port = mkOption {
      type = types.port;
      default = 41641;
      description = "UDP port for Tailscale WireGuard traffic.";
    };

    interfaceName = mkOption {
      type = types.str;
      default = "tailscale0";
      description = "Name of the Tailscale network interface.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for Tailscale UDP port.";
    };

    trustInterface = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to trust the Tailscale network interface in the firewall.";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      command = "${cfg.package}/bin/tailscaled";
      args = [
        "--port"
        (toString cfg.port)
        "--tun"
        cfg.interfaceName
      ];
      restartPolicy = "on-failure";

      ports.wireguard = {
        port = cfg.port;
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

      systemd = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
