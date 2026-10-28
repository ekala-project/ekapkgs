{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kitemviews,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdebugsettings";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kdebugsettings-${finalAttrs.version}.tar.xz";
    hash = "sha256-3C9FqawAAsbrbfxZEzJGD9Api5cOc7+9vJgEhMnWfmE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kitemviews
    kwidgetsaddons
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "Application to choose which QLoggingCategory are displayed";
    homepage = "https://apps.kde.org/kdebugsettings/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kdebugsettings";
  };
})
