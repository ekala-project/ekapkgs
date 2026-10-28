{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  knewstuff,
  knotifications,
  libkeduvocdocument,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "khangman";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/khangman-${finalAttrs.version}.tar.xz";
    hash = "sha256-MdWk1MWb8SM2wnxBdaYDJ8nKr3tFlnCPQh5ynj6RYpY=";
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
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kio
    knewstuff
    knotifications
    libkeduvocdocument
  ];

  meta = {
    description = "A hangman game";
    homepage = "https://apps.kde.org/khangman/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "khangman";
  };
})
