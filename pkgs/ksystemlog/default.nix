{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  audit,
  karchive,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kitemviews,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksystemlog";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ksystemlog-${finalAttrs.version}.tar.xz";
    hash = "sha256-Fl9rJuXLqrE/hbfT3EoNNNhAAY/S4B7W8Xqjiri4QGs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    audit
    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kio
    kitemviews
    ktextwidgets
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "KDE SystemLog Application";
    homepage = "https://apps.kde.org/ksystemlog/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ksystemlog";
  };
})
