{
  lib,
  SDL2,
  SDL2_net,
  alsa-lib,
  fetchurl,
  flac,
  libglut,
  libGL,
  libGLU,
  libx11,
  libcdio,
  libjack2,
  libsamplerate,
  libsndfile,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mednafen";
  version = "1.32.1";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/mednafen-${finalAttrs.version}.tar.xz";
    hash = "sha256-3n65SrZiEq53WDdlJDaKirIII0szeWYlymMFR9vIODI=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_net
    flac
    libglut
    libcdio
    libjack2
    libsamplerate
    libsndfile
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libGL
    libGLU
    libx11
  ];

  hardeningDisable = [
    "format"
    "pic"
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  postInstall = ''
    mkdir -p $doc/share/doc
    mv Documentation $doc/share/doc/mednafen
  '';

  meta = {
    homepage = "https://mednafen.github.io/";
    description = "Portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mednafen";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
