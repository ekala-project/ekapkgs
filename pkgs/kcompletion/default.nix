{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kconfig,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcompletion";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcompletion-${finalAttrs.version}.tar.xz";
    hash = "sha256-lq2cQpylO4MDWcRWFMpMMu1rdZ8wI/Gz2xZQuhwZvVg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    kcodecs
    kconfig
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Text completion helpers and widgets";
    homepage = "https://invent.kde.org/frameworks/kcompletion";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
