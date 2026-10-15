{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kplotting";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kplotting-${finalAttrs.version}.tar.xz";
    hash = "sha256-9aZ76FwhZl4FI3EwGIlEMZa53ls5J6/zU6PT4ncw3RE=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Lightweight plotting framework";
    homepage = "https://invent.kde.org/frameworks/kplotting";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
