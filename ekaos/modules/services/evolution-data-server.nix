# Evolution Data Server — calendar, contacts, and tasks backend
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.evolution-data-server;
in

{
  options.services.gnome.evolution-data-server = {
    enable = mkEnableOption "Evolution Data Server, a collection of services for storing addressbooks and calendars";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.evolution-data-server ];

    services.dbus.packages = [ pkgs.evolution-data-server ];

    systemd.packages = [ pkgs.evolution-data-server ];
  };
}
