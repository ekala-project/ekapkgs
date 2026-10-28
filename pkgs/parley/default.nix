{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  knewstuff,
  knotifications,
  ktextwidgets,
  kxmlgui,
  libkeduvocdocument,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parley";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/parley-${finalAttrs.version}.tar.xz";
    hash = "sha256-5g8C5tJT4B707Hc/NbonJRl14A0g29lemAmh0B/oQW4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtwebengine
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kio
    knewstuff
    knotifications
    ktextwidgets
    kxmlgui
    libkeduvocdocument
    sonnet
  ];

  meta = {
    description = "Vocabulary Trainer";
    homepage = "https://apps.kde.org/parley/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "parley";
  };
})
