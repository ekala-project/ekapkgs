{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kglobalaccel,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  knotifications,
  knotifyconfig,
  kparts,
  kstatusnotifieritem,
  kwidgetsaddons,
  kwindowsystem,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yakuake";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/yakuake-${finalAttrs.version}.tar.xz";
    hash = "sha256-fwzoYhjtE8Q+DNVEwRWDqXAJlZU8voZC2qPg1nWFujY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    karchive
    kcolorscheme
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    ki18n
    kiconthemes
    kio
    knewstuff
    knotifications
    knotifyconfig
    kparts
    kstatusnotifieritem
    kdePackages.kwayland
    kwidgetsaddons
    kwindowsystem
  ];

  meta = {
    description = "Drop-down terminal emulator based on Konsole technologies";
    homepage = "https://apps.kde.org/yakuake/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "yakuake";
  };
})
