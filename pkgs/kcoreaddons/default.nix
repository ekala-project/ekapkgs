{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcoreaddons";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcoreaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-zGj+Fb6w/KIDbP+HQvRowTRUBr+ZeT//rL+PKj+JvEs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Addons to QtCore";
    homepage = "https://invent.kde.org/frameworks/kcoreaddons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
