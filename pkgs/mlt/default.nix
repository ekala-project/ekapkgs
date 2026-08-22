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
  SDL2,
  libarchive,
}:

let
  # Use ffmpeg without libaom to avoid nasm build issues
  ffmpegFixed = ffmpeg.override { withAom = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlt";
  version = "7.40.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rw1jnQJzbtpGsIe/AFMiy7k/3X0vkfkY3rG4E419aVM=";
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
    SDL2
    libx11
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
    (lib.cmakeBool "MOD_OPENCV" false)
    (lib.cmakeBool "MOD_SOX" false)
    (lib.cmakeBool "MOD_RTAUDIO" false)
    (lib.cmakeBool "MOD_QT6" false)
    (lib.cmakeBool "MOD_GLAXNIMATE_QT6" false)
    (lib.cmakeBool "RELOCATABLE" false)
  ];

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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
