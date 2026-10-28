{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  libvlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phonon-vlc";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/phonon-backend-vlc/${finalAttrs.version}/phonon-backend-vlc-${finalAttrs.version}.tar.xz";
    hash = "sha256-M4R53EUeS5SzyltXje90Hc+C9cYmooB9NiNb4tznyaU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    libvlc
  ];

  cmakeEntries = {
    PHONON_BUILD_QT5 = false;
    PHONON_BUILD_QT6 = true;
  };

  meta = {
    description = "Phonon VLC backend";
    homepage = "https://community.kde.org/Phonon";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
