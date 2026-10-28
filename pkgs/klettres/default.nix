{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  knewstuff,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "klettres";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/klettres-${finalAttrs.version}.tar.xz";
    hash = "sha256-VgToypHHGasvVNwtTWTjnCLb2NCiYzxqZEZfoJMpzEg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    knewstuff
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Learn The Alphabet";
    homepage = "https://apps.kde.org/klettres/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "klettres";
  };
})
