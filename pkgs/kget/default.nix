{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  kitemviews,
  knotifications,
  knotifyconfig,
  kservice,
  kstatusnotifieritem,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  qgpgme,
  libmms,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kget";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kget-${finalAttrs.version}.tar.xz";
    hash = "sha256-OpnHhZLh1TlAACoOV+TdP8BY3Es69ro3K3f4Ejx3MK4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kitemviews
    knotifications
    knotifyconfig
    kservice
    kstatusnotifieritem
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    qgpgme
    libmms
  ];

  meta = {
    description = "Download Manager";
    homepage = "https://invent.kde.org/network/kget";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kget";
  };
})
