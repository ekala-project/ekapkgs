{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phonon";
  version = "4.12.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${finalAttrs.version}/phonon-${finalAttrs.version}.tar.xz";
    hash = "sha256-Mof/4PvMLUqhNj+eFXRzAtCwgAkP525fIR2AnstD85o=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    libGLU
    libGL
    libpulseaudio
    qt6.qt5compat
    qt6.qtbase
  ];

  cmakeEntries = {
    PHONON_BUILD_QT5 = false;
    PHONON_BUILD_QT6 = true;
    # Do not expose upstream's unstable experimental API.
    PHONON_BUILD_EXPERIMENTAL = false;
  };

  meta = {
    description = "Phonon multimedia framework";
    mainProgram = "phononsettings";
    homepage = "https://community.kde.org/Phonon";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
