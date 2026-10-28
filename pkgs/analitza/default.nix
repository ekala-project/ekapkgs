{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "analitza";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/analitza-${finalAttrs.version}.tar.xz";
    hash = "sha256-+W1OzMIFfXD6VdpoKUKOKimO6+hZJi3qKiaMRMz6owk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qt5compat
    qt6.qtsvg
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    eigen
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library that lets you add mathematical features to your program";
    homepage = "https://invent.kde.org/education/analitza";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
