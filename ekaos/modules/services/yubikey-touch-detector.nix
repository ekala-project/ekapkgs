# yubikey-touch-detector — detect when YubiKey is waiting for a touch
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.yubikey-touch-detector;
in

{
  options.services.yubikey-touch-detector = {
    enable = mkEnableOption "yubikey-touch-detector, a tool to detect when your YubiKey is waiting for a touch";

    package = mkOption {
      type = types.package;
      default = pkgs.yubikey-touch-detector;
      description = "yubikey-touch-detector package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Enable the user service and socket
    systemd.user.services.yubikey-touch-detector = {
      wantedBy = [ "default.target" ];
    };

    systemd.user.sockets.yubikey-touch-detector = {
      wantedBy = [ "sockets.target" ];
    };
  };
}
