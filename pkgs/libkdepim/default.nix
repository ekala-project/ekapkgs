{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  ki18n,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkdepim";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkdepim-${finalAttrs.version}.tar.xz";
    hash = "sha256-SiTAbXL7H5WphRn2aEfSzwacLhXNr+ryMhBR1W0Y3dU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kcompletion
    ki18n
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library for common KDE PIM applications";
    homepage = "https://invent.kde.org/pim/libkdepim";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
