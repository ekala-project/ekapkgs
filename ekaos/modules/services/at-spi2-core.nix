# AT-SPI2 — Assistive Technologies Service Provider Interface
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.at-spi2-core = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable at-spi2-core, a service for the Assistive Technologies
        available on the GNOME platform.

        Enable this if you get the error or warning
        `The name org.a11y.Bus was not provided by any .service files`.
      '';
    };
  };

  config = mkMerge [
    (mkIf config.services.gnome.at-spi2-core.enable {
      environment.systemPackages = [ pkgs.at-spi2-core ];
      services.dbus.packages = [ pkgs.at-spi2-core ];
      systemd.packages = [ pkgs.at-spi2-core ];
    })

    (mkIf (!config.services.gnome.at-spi2-core.enable) {
      environment.sessionVariables = {
        NO_AT_BRIDGE = "1";
        GTK_A11Y = "none";
      };
    })
  ];
}
