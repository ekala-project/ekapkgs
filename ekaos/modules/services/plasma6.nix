# Plasma 6 Desktop Environment
#
# NOT YET FUNCTIONAL — This is a skeleton module.
#
# Plasma 6 requires approximately 427 KDE packages that are not yet
# available in ekapkgs:
#
#   - KDE Frameworks 6 (~80 packages): extra-cmake-modules, kcoreaddons,
#     kconfig, ki18n, kio, kauth, solid, kservice, kwallet, kirigami, ...
#   - Plasma Desktop (~60 packages): plasma-desktop, plasma-workspace,
#     kwin, kscreen, kactivitymanagerd, drkonqi, plasma-integration, ...
#   - KDE Applications (~50+ packages): dolphin, konsole, kate, okular,
#     spectacle, ark, gwenview, ...
#   - Qt6 additional modules: qtwayland, qtmultimedia, qt5compat, ...
#   - Themes: breeze, breeze-icons, breeze-gtk, ocean-sound-theme, ...
#
# Prerequisites:
#   1. Port Qt6 modules beyond qtbase
#   2. Port KDE Frameworks 6 (depends on Qt6 + extra-cmake-modules)
#   3. Port Plasma Desktop packages (depends on KF6)
#   4. Port KDE Applications (depends on KF6 + Plasma)
#   5. Establish a kdePackages scope in ekapkgs
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.desktopManager.plasma6;
in

{
  options.services.desktopManager.plasma6 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable the Plasma 6 desktop environment.

        NOTE: This module is not yet functional. Enabling it will produce
        an assertion error listing the missing dependencies.
      '';
    };

    enableQt5Integration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Qt5 integration for legacy applications.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = false;
        message = ''
          services.desktopManager.plasma6 is not yet functional.

          Plasma 6 requires ~427 KDE packages that are not yet available
          in ekapkgs. The following package categories must be ported first:

            - KDE Frameworks 6 (kcoreaddons, kconfig, ki18n, kio, ...)
            - Plasma Desktop (plasma-desktop, plasma-workspace, kwin, ...)
            - KDE Applications (dolphin, konsole, kate, ...)
            - Additional Qt6 modules (qtwayland, qtmultimedia, ...)
            - Breeze themes and icons

          See the module source for the full list of prerequisites.
        '';
      }
    ];
  };
}
