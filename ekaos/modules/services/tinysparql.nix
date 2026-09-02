# TinySPARQL — search engine and metadata storage system
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.tinysparql;
in

{
  options.services.gnome.tinysparql = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable TinySPARQL services, a search engine,
        search tool and metadata storage system.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tinysparql ];

    services.dbus.packages = [ pkgs.tinysparql ];

    systemd.packages = [ pkgs.tinysparql ];
  };
}
