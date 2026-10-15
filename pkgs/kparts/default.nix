{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kio,
  knotifications,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kparts";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kparts-6.30.0.tar.xz";
    hash = "sha256-mfWg46TaEOGg+/tQWulmzYdif4h90HkpqSCv5ByGKsA=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    kio
    knotifications
    kxmlgui
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE plugin framework for user interface components";
    homepage = "https://invent.kde.org/frameworks/kparts";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
