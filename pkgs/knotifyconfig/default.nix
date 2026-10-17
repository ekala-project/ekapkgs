{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ki18n,
  kio,
  knotifications,
  kxmlgui,
  libcanberra,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knotifyconfig";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/knotifyconfig-6.30.0.tar.xz";
    hash = "sha256-ShM97NsNNzHbqh02JbMPBXCJ5cWcgyb/iKBHzvNbLvs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libcanberra
  ];

  propagatedBuildInputs = [
    ki18n
    kio
    knotifications
    kxmlgui
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE notification configuration";
    homepage = "https://invent.kde.org/frameworks/knotifyconfig";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
