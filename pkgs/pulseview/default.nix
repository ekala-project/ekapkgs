{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  ninja,
  glib,
  boost,
  libsigrok,
  libsigrokdecode,
  libserialport,
  libzip,
  libftdi1,
  hidapi,
  glibmm_2_4,
  python3,
  bluez,
  qt5,
}:

stdenv.mkDerivation {
  pname = "pulseview";
  version = "0.5.0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "sigrokproject";
    repo = "pulseview";
    rev = "af02198741b4e57c9f9b796bd5e6c0f2ae9f2f2b";
    hash = "sha256-4K3sMCTlFnu8iiokMYc1O7jNVQ7vTtSiT2dCpLRC44s=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    glib
    boost
    libsigrok
    libsigrokdecode
    libserialport
    libzip
    libftdi1
    hidapi
    glibmm_2_4
    python3
    qt5.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  meta = {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    mainProgram = "pulseview";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
