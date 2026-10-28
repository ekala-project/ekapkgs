{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  shared-mime-info,
  karchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpkpass";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kpkpass-${finalAttrs.version}.tar.xz";
    hash = "sha256-HiaeKhUX+RzNB3bcE3/s6BufG8I+3IzO2QKLE4qVzB4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    karchive
  ];

  meta = {
    description = "Library to deal with Apple Wallet pass files";
    homepage = "https://invent.kde.org/pim/kpkpass";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
