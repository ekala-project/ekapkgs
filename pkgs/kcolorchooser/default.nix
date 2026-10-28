{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  ki18n,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcolorchooser";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcolorchooser-${finalAttrs.version}.tar.xz";
    hash = "sha256-29IewSoiDE87w9353DUTs44g8eyl2SlhpjXMf++C2s4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    ki18n
    kxmlgui
  ];

  meta = {
    description = "A small utility to select a color";
    homepage = "https://apps.kde.org/kcolorchooser/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "kcolorchooser";
  };
})
