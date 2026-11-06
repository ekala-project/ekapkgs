# Steam — gaming platform with optional Gamescope and GameMode
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.steam;
in

{
  options.programs.steam = {
    enable = mkEnableOption "Steam digital distribution platform";

    package = mkOption {
      type = types.package;
      default = pkgs.steam;
      description = "Steam package to use.";
    };

    remotePlay.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports for Steam Remote Play.";
    };

    dedicatedServer.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports for Steam dedicated servers.";
    };

    localNetworkGameTransfers.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports for Steam local network game transfers.";
    };

    gamescope = {
      enable = mkEnableOption "Gamescope compositor session for Steam";

      package = mkOption {
        type = types.package;
        default = pkgs.gamescope;
        description = "Gamescope package to use.";
      };
    };

    gamemode = {
      enable = mkEnableOption "GameMode performance optimization";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to include in the Steam FHS environment.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [
        cfg.package
      ];

      # Steam controller udev rules
      services.udev.packages = [ pkgs.steam-unwrapped ];

      # 32-bit driver support for Steam
      hardware.graphics.enable32Bit = mkDefault true;
    }

    (mkIf cfg.gamescope.enable {
      environment.systemPackages = [ cfg.gamescope.package ];

      security.wrappers.gamescope = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice+ep";
        source = "${cfg.gamescope.package}/bin/gamescope";
      };
    })

    (mkIf cfg.gamemode.enable {
      environment.systemPackages = [ pkgs.gamemode ];
    })

    # Remote Play ports
    (mkIf cfg.remotePlay.openFirewall {
      networking.firewall = {
        allowedTCPPorts = [ 27036 ];
        allowedUDPPorts = [
          27031
          27036
        ];
      };
    })

    # Dedicated server ports
    (mkIf cfg.dedicatedServer.openFirewall {
      networking.firewall = {
        allowedTCPPorts = [ 27015 ];
        allowedUDPPorts = [
          27015
          27020
        ];
      };
    })

    # Local network game transfer ports
    (mkIf cfg.localNetworkGameTransfers.openFirewall {
      networking.firewall.allowedTCPPorts = [ 27040 ];
    })
  ]);
}
