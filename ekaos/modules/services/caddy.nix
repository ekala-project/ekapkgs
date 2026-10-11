# caddy — HTTP/2 web server with automatic HTTPS
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.caddy;
in

{
  options.services.caddy = {
    enable = mkEnableOption "Caddy, an HTTP/2 web server with automatic HTTPS";

    package = mkOption {
      type = types.package;
      default = pkgs.caddy;
      description = "Caddy package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.caddy = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
