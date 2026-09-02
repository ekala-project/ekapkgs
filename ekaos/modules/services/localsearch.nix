# LocalSearch — indexing services for TinySPARQL
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.localsearch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable LocalSearch, indexing services for TinySPARQL
        search engine and metadata storage system.
      '';
    };
  };

  config = mkIf config.services.gnome.localsearch.enable {
    environment.systemPackages = [ pkgs.localsearch ];

    services.dbus.packages = [ pkgs.localsearch ];

    systemd.packages = [ pkgs.localsearch ];
  };
}
