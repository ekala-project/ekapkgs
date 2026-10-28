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
  kiconthemes,
  kitemviews,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kgeography";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kgeography-${finalAttrs.version}.tar.xz";
    hash = "sha256-/ee9nidXhuYBGDkM8NEGlkE8QE4HcltCBVns26+q7k0=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kitemviews
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Geography Trainer";
    homepage = "https://apps.kde.org/kgeography/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kgeography";
  };
})
