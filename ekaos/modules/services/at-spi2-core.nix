# AT-SPI2 accessibility service
# D-Bus activated — no service contract needed
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.at-spi2-core;
in

{
  options.services.gnome.at-spi2-core = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the AT-SPI2 D-Bus accessibility service.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.at-spi2-core;
      description = "at-spi2-core package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Install at-spi2-core package
    environment.systemPackages = [ cfg.package ];

    # Set accessibility environment variables
    environment.variables = {
      NO_AT_BRIDGE = "0";
      GTK_A11Y = "atspi";
    };

    # Ensure D-Bus can find the at-spi2 service files
    services.dbus.packages = [ cfg.package ];
  };
}
