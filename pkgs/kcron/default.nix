{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kauth,
  kcmutils,
  kconfigwidgets,
  kcoreaddons,
  kdoctools,
  ki18n,
  kirigami-addons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcron";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kcron-${finalAttrs.version}.tar.xz";
    hash = "sha256-MTdRiqpxCkb/CXTx8gYIS53eYI8+vJ8/SMBq1HjTDes=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kauth
    kcmutils
    kconfigwidgets
    kcoreaddons
    ki18n
    kirigami-addons
  ];

  meta = {
    description = "Task scheduler by KDE";
    homepage = "https://apps.kde.org/kcron/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
