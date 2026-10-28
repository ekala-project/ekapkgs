{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  ktexteditor,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "umbrello";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/umbrello-${finalAttrs.version}.tar.xz";
    hash = "sha256-PsHn578Wf95RMTpwljXNlG/Sf7YufTJV8YRMdq+qCs8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kio
    ktexteditor
    kwidgetsaddons
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "GUI for diagramming Unified Modelling Language (UML)";
    homepage = "https://apps.kde.org/umbrello/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
