{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdbusaddons,
  kdnssd,
  ki18n,
  kio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kio-zeroconf";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kio-zeroconf-${finalAttrs.version}.tar.xz";
    hash = "sha256-vddJz6fU/KESQTz4RMlhnwMa2wJb1NSPn1ddWvrVOqI=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kdbusaddons
    kdnssd
    ki18n
    kio
  ];

  meta = {
    description = "KIO worker to discover file systems by DNS-SD (zeroconf)";
    homepage = "https://apps.kde.org/kio-zeroconf/";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Only
    ];
    platforms = lib.platforms.linux;
  };
})
