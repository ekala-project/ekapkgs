{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmouth";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmouth-${finalAttrs.version}.tar.xz";
    hash = "sha256-QchjWRxEZX0m7SQSkt1o5kHRUyay0KPkJaHnecFiPPI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtspeech
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kio
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "Type-and-say front end for speech synthesizers";
    homepage = "https://apps.kde.org/kmouth/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmouth";
  };
})
