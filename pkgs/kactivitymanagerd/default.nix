{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  boost,
  kauth,
  kcodecs,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kglobalaccel,
  ki18n,
  kio,
  kservice,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kactivitymanagerd";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kactivitymanagerd-${finalAttrs.version}.tar.xz";
    hash = "sha256-blSbDazSh5cVNpbk7if44ZrubzcR+U7jebj66Oz9k3o=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    boost
    kauth
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    ki18n
    kio
    kservice
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "System service to manage user's activities and track the usage patterns";
    homepage = "https://invent.kde.org/plasma/kactivitymanagerd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
