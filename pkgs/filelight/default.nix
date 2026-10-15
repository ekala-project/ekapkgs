{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kconfig,
  kcrash,
  kdoctools,
  ki18n,
  kio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "filelight";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/filelight-${finalAttrs.version}.tar.xz";
    hash = "sha256-yAJSG+9s3OUTqVw8R7algdC/Xfs8hSux0s0NfC5plRs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kcolorscheme
    kconfig
    kcrash
    ki18n
    kio
  ];

  meta = {
    description = "Disk usage visualizer";
    homepage = "https://apps.kde.org/filelight/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "filelight";
  };
})
