{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kdoctools,
  ki18n,
  kio,
  kxmlgui,
  libgphoto2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kamera";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kamera-${finalAttrs.version}.tar.xz";
    hash = "sha256-Wwqnbs4tiUkXBPdpQDNSo9jeJpnIWoP5QQaRA+5evgI=";
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
    kcmutils
    kconfig
    kconfigwidgets
    ki18n
    kio
    kxmlgui
    libgphoto2
  ];

  meta = {
    description = "KDE integration for gphoto2 cameras";
    homepage = "https://invent.kde.org/graphics/kamera";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
