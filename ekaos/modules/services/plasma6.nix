# Plasma 6 desktop environment (stub)
# TODO: Requires Qt6 and KDE Frameworks 6 package stack
{
  config,
  lib,
  ...
}:

with lib;

{
  options.services.desktopManager.plasma6 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the KDE Plasma 6 desktop environment.

        NOTE: Plasma 6 is not yet available in ekapkgs.
        Qt6 and KDE Frameworks 6 must be ported first.
      '';
    };
  };

  config = mkIf config.services.desktopManager.plasma6.enable {
    assertions = [
      {
        assertion = false;
        message = ''
          services.desktopManager.plasma6.enable is true, but Plasma 6 is not yet
          available in ekapkgs. The Qt6 and KDE Frameworks 6 package stack must be
          ported first. Disable this option or use an available window manager
          (i3, sway, bspwm, etc.) instead.
        '';
      }
    ];
  };
}
