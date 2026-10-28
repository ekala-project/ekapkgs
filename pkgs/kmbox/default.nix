{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kmime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmbox";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmbox-${finalAttrs.version}.tar.xz";
    hash = "sha256-pLCJFVhNC37F+iitrh6z0LxjodlfFeQL+uUpUF0DB6U=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kmime
  ];

  meta = {
    description = "Library for accessing MBox format mail storages";
    homepage = "https://invent.kde.org/pim/kmbox";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
