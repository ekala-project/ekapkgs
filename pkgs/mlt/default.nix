{
  alsa-lib,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  ffmpeg,
  fftw,
  fontconfig,
  frei0r,
  libdv,
  libebur128,
  libexif,
  libjack2,
  libsamplerate,
  libvorbis,
  libxml2,
  libx11,
  lilv,
  makeWrapper,
  movit,
  pango,
  rnnoise,
  rtaudio ? null,
  rubberband,
  sox ? null,
  vid-stab,
  enableJackrack ? stdenv.hostPlatform.isLinux,
  gdk-pixbuf,
  glib,
  ladspa-sdk,
  ladspaPlugins,
  enableSDL2 ? true,
  sdl2-compat,
  libarchive,
}:

let
  # Use ffmpeg without libaom to avoid nasm build issues
  ffmpegFixed = ffmpeg.override { withAom = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlt";
  version = "7.42.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uVjCehivKx/45AC3+uFF8HtzmydO13JuFvlvHwG4SSw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    which
    makeWrapper
  ];

  buildInputs = [
    gdk-pixbuf
    ffmpegFixed
    fftw
    fontconfig
    frei0r
    libdv
    libebur128
    libexif
    libjack2
    libsamplerate
    libvorbis
    libxml2
    lilv
    movit
    pango
    rnnoise
    rubberband
    vid-stab
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals enableJackrack [
    glib
    ladspa-sdk
    ladspaPlugins
  ]
  ++ lib.optionals enableSDL2 [
    sdl2-compat
    libx11
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeEntries = {
    CMAKE_SKIP_BUILD_RPATH = true;
    MOD_OPENCV = false;
    MOD_SOX = false;
    MOD_RTAUDIO = false;
    MOD_QT6 = false;
    MOD_GLAXNIMATE_QT6 = false;
    RELOCATABLE = false;
  };

  preFixup = ''
    wrapProgram $out/bin/melt \
      --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1 \
      ${lib.optionalString enableJackrack "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"}
  '';

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mlt-framework-7.pc \
      --replace-fail '=''${prefix}//' '=/'
  '';

  passthru = {
    inherit ffmpegFixed;
  };

  meta = {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org/";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
