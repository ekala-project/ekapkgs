{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  # transports
  curl,
  libmms,
  # input plugins
  libmad,
  taglib,
  libvorbis,
  libogg,
  flac,
  libmpcdec,
  libmodplug,
  libsndfile,
  libcdio,
  cdparanoia,
  libcddb,
  faad2,
  ffmpeg,
  wildmidi,
  libbs2b,
  game-music-emu,
  libarchive,
  opusfile,
  soxr,
  wavpack,
  libxmp,
  libsidplayfp,
  # output plugins
  alsa-lib,
  libpulseaudio,
  pipewire,
  libjack2,
  # effect plugins
  libsamplerate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qmmp";
  version = "2.3.3";

  src = fetchurl {
    url = "https://qmmp.ylsoftware.com/files/qmmp/2.3/qmmp-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Uclk6eaFz2cmay6OMTXuRQS2v2sig/Rrv9Sr42rjaQ0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    # basic requirements
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    # transports
    curl
    libmms
    # input plugins
    libmad
    taglib
    libvorbis
    libogg
    flac
    libmpcdec
    libmodplug
    libsndfile
    libcdio
    cdparanoia
    libcddb
    faad2
    ffmpeg
    wildmidi
    libbs2b
    game-music-emu
    libarchive
    opusfile
    soxr
    wavpack
    libxmp
    libsidplayfp
    # output plugins
    alsa-lib
    libpulseaudio
    pipewire
    libjack2
    # effect plugins
    libsamplerate
  ];

  meta = {
    description = "Qt-based audio player that looks like Winamp";
    mainProgram = "qmmp";
    homepage = "https://qmmp.ylsoftware.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
