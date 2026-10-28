{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kdoctools,
  ki18n,
  kio,
  solid,
  cdparanoia,
  flac,
  libogg,
  libvorbis,
  lame,
  opus-tools,
  libkcddb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audiocd-kio";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/audiocd-kio-${finalAttrs.version}.tar.xz";
    hash = "sha256-+TboE+qlUVojZbEPYjhhMin2oX+hCoZtfKINT5XAd4w=";
  };

  # TODO: encoder-paths.patch for lame/opusenc

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcmutils
    kconfig
    ki18n
    kio
    solid
    cdparanoia
    flac
    libogg
    libvorbis
    libkcddb
  ];

  meta = {
    description = "KIO worker for accessing audio CDs";
    homepage = "https://apps.kde.org/audiocd-kio/";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      gpl3Only
      lgpl3Plus
    ];
    platforms = lib.platforms.linux;
  };
})
