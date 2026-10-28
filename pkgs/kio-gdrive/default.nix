{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  ki18n,
  kio,
  purpose,
  qtkeychain,
  kaccounts-integration,
  libkgapi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kio-gdrive";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kio-gdrive-${finalAttrs.version}.tar.xz";
    hash = "sha256-uc5NEONNBgdH+zNGqMTTh1p+2HwhA1sUO/sUEBOaS0M=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    ki18n
    kio
    purpose
    qtkeychain
    kaccounts-integration
    libkgapi
  ];

  meta = {
    description = "KIO Worker to access Google Drive";
    homepage = "https://apps.kde.org/kio-gdrive/";
    license = with lib.licenses; [
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
