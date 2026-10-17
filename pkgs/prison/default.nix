{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  zxing-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prison";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/prison-6.30.0.tar.xz";
    hash = "sha256-LNsKJomrRbkHx2yaAcHcFIVbjlMprQqc9lwa1k5f7Rs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
  ];

  propagatedBuildInputs = [
    zxing-cpp
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE barcode and QR code API";
    homepage = "https://invent.kde.org/frameworks/prison";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
