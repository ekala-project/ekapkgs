{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  pulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pulseaudio-qt";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://kde/stable/pulseaudio-qt/pulseaudio-qt-${finalAttrs.version}.tar.xz";
    hash = "sha256-wqrOOsGpyMm5xXug/8maPTEHN8wATbBJGALgNTbifGk=";
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
    pulseaudio
  ];

  meta = {
    description = "Qt bindings for libpulse";
    homepage = "https://invent.kde.org/libraries/pulseaudio-qt";
    license = with lib.licenses; [
      lgpl21Only
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})
