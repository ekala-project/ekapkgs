{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  ki18n,
  kirigami-addons,
  kitemmodels,
  networkmanager-qt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpublictransport";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kpublictransport-${finalAttrs.version}.tar.xz";
    hash = "sha256-kpsOEklIkrTjBmkZAG4Nj0fTYREeQr3gUC37Y46T/mA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtlocation
    ki18n
    kirigami-addons
    kitemmodels
    networkmanager-qt
  ];

  meta = {
    description = "Library to assist with accessing public transport timetables and other data";
    homepage = "https://apps.kde.org/kpublictransport/";
    license = with lib.licenses; [
      bsd2
      bsd3
      lgpl2Plus
      lgpl21Plus
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
