{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kcolorscheme,
  kcompletion,
  kconfig,
  kcoreaddons,
  ki18n,
  kitemmodels,
  ktextaddons,
  kwidgetsaddons,
  boost,
  qgpgme,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkleo";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/libkleo-${finalAttrs.version}.tar.xz";
    hash = "sha256-cNzlL61i0yoxIlQr+076IM0eDj3pInO8uq5wTzLtPzI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kcodecs
    kcolorscheme
    kcompletion
    kconfig
    kcoreaddons
    ki18n
    kitemmodels
    ktextaddons
    kwidgetsaddons
    boost
  ];

  propagatedBuildInputs = [
    qgpgme
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Library that provides cryptography support for mails";
    homepage = "https://invent.kde.org/pim/libkleo";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
