# Sushi — quick file previewer for Nautilus
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.gnome.sushi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Sushi, a quick previewer for Nautilus.";
    };
  };

  config = mkIf config.services.gnome.sushi.enable {
    environment.systemPackages = [ pkgs.sushi ];

    services.dbus.packages = [ pkgs.sushi ];
  };
}
