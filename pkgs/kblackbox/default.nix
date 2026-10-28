{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kdoctools,
  karchive,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kblackbox";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kblackbox-${finalAttrs.version}.tar.xz";
    hash = "sha256-cuq4y39QWGGTv9Op+BBFC9dw1diU6GfhgaqGqIlpqiE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    karchive
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KBlackBox is a game of hide and seek played on a grid of boxes";
    homepage = "https://apps.kde.org/kblackbox/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kblackbox";
  };
})
