{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  ki18n,
  kparts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svgpart";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/svgpart-${finalAttrs.version}.tar.xz";
    hash = "sha256-n2p6TZPnAhAs+cMD/t3IflTe7vZkK+Fl7H+xaBnbMho=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kcoreaddons
    ki18n
    kparts
  ];

  meta = {
    description = "A KPart for SVG support";
    homepage = "https://apps.kde.org/svgpart/";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
