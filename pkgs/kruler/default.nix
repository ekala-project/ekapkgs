{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcrash,
  kdoctools,
  ki18n,
  knotifications,
  kstatusnotifieritem,
  kwindowsystem,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kruler";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kruler-${finalAttrs.version}.tar.xz";
    hash = "sha256-5aVUTaBDsGf+7/OGiQy5wKUpJidJNVncfGSdyU4gH2c=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcrash
    ki18n
    knotifications
    kstatusnotifieritem
    kwindowsystem
    kxmlgui
  ];

  meta = {
    description = "A pixel measuring tool by KDE";
    homepage = "https://apps.kde.org/kruler/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kruler";
  };
})
