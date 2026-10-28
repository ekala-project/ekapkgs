{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiten";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kiten-${finalAttrs.version}.tar.xz";
    hash = "sha256-7gfjRQ3YNfhuwVv9vADQsU6NMDC0Fz1mUPGiPSYTvJw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    karchive
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kio
    kxmlgui
  ];

  meta = {
    description = "Japanese Reference/Study Tool";
    homepage = "https://apps.kde.org/kiten/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kiten";
  };
})
