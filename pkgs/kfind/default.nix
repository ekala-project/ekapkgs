{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcoreaddons,
  kcrash,
  kdoctools,
  kfilemetadata,
  ki18n,
  kio,
  kwidgetsaddons,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kfind";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kfind-${finalAttrs.version}.tar.xz";
    hash = "sha256-lkDnzWR9olxLWxVJAW9CSj1bcidRsjNm1xCEnNFNBcU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    karchive
    kcoreaddons
    kcrash
    kfilemetadata
    ki18n
    kio
    kwidgetsaddons
    kxmlgui
  ];

  meta = {
    description = "File search utility by KDE";
    homepage = "https://apps.kde.org/kfind/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kfind";
  };
})
