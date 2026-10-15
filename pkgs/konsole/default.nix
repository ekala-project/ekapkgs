{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kbookmarks,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  knotifications,
  knotifyconfig,
  kparts,
  kpty,
  kservice,
  ktextwidgets,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  libssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "konsole";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/konsole-${finalAttrs.version}.tar.xz";
    hash = "sha256-IVSgOpUsKb5DXe//1MiPnS7/RKVc36M7Fqj8e/2Xghc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    kbookmarks
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    kguiaddons
    ki18n
    kiconthemes
    kio
    knewstuff
    knotifications
    knotifyconfig
    kparts
    kpty
    kservice
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    libssh
  ];

  meta = {
    description = "KDE terminal emulator";
    homepage = "https://apps.kde.org/konsole/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "konsole";
  };
})
