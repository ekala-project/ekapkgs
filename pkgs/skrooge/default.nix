{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  sqlcipher,
  libofx,
  shared-mime-info,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skrooge";
  version = "26.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/skrooge/skrooge-${finalAttrs.version}.tar.xz";
    hash = "sha256-TkrFiXZUsp+sTt3bW1lrKqJvNvBI8Jo8R8x947SdjCI=";
  };

  nativeBuildInputs = with kdePackages; [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    kdoctools
    pkg-config
    shared-mime-info
    wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    qtwebengine
    kxmlgui
    kwallet
    kparts
    kjobwidgets
    kiconthemes
    knewstuff
    sqlcipher
    qca
    plasma-activities
    karchive
    kguiaddons
    knotifyconfig
    krunner
    ktexttemplate
    kwindowsystem
    libofx
  ];

  cmakeFlags = [
    "-DQT_MAJOR_VERSION=6"
    "-DSKG_DESIGNER=OFF"
    "-DSKG_WEBENGINE=ON"
    "-DSKG_WEBKIT=OFF"
    "-DBUILD_TESTS=OFF"
  ];

  meta = {
    description = "Personal finances manager, powered by KDE";
    license = lib.licenses.gpl3;
    homepage = "https://skrooge.org/";
  };
})
