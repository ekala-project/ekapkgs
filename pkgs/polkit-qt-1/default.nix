{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  glib,
  polkit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polkit-qt-1";
  version = "0.201.1";

  src = fetchurl {
    url = "mirror://kde/stable/polkit-qt-1/polkit-qt-1-${finalAttrs.version}.tar.xz";
    hash = "sha256-ldjiyuUwxUbZQ3RZ3rihvqONVy8Pl3LMKGDcFDY38lY=";
  };

  patches = [ ./full-paths.patch ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    glib
    polkit
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Qt wrapper around polkit-1 client libraries";
    homepage = "https://invent.kde.org/libraries/polkit-qt-1";
    license = with lib.licenses; [ bsd3 gpl2Plus lgpl2Plus ];
    platforms = lib.platforms.unix;
  };
})
