{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
}:

stdenv.mkDerivation rec {
  pname = "wildmidi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Mindwerks";
    repo = "wildmidi";
    rev = "${pname}-${version}";
    sha256 = "sha256-KFJW2m7TJ0RExK/C0XHyOefKGFLUszl7Jh6l10NjeHM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = lib.optionals stdenv.buildPlatform.isLinux [
    alsa-lib
    stdenv.cc.libc
  ];

  preConfigure = ''
    substituteInPlace src/wildmidi.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = {
    description = "Software MIDI player and library";
    mainProgram = "wildmidi";
    homepage = "https://wildmidi.sourceforge.net/";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
  };
}
