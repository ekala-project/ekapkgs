{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kglobalaccel";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kglobalaccel-${finalAttrs.version}.tar.xz";
    hash = "sha256-5TLr1Mv8jW15xsOMVW8YcTFf7a6NsrabV0ucSW8XFHM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Add support for global workspace shortcuts";
    homepage = "https://invent.kde.org/frameworks/kglobalaccel";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
