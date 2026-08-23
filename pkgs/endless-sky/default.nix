{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libavif ? null,
  libpng,
  libjpeg,
  libogg,
  libsm ? null,
  libx11,
  libxext ? null,
  flac,
  glew,
  openal,
  cmake,
  pkg-config,
  libmad,
  libuuid,
  minizip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endless-sky";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v+0RrZqIkF849D8rmOhYS1kqeeCPRcBED+3VPSuhGF0=";
  };

  patches = [
    ./fixes.patch
  ];

  postPatch = ''
    substituteInPlace source/Files.cpp \
      --replace-fail '%NIXPKGS_RESOURCES_PATH%' "$out/share/games/endless-sky/"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    libpng
    libjpeg
    libogg
    flac
    openal
    libmad
    minizip
    libx11
    glew
    libuuid
  ]
  ++ lib.optional (libavif != null) libavif
  ++ lib.optional (libsm != null) libsm
  ++ lib.optional (libxext != null) libxext;

  meta = {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    changelog = "https://github.com/endless-sky/endless-sky/blob/v${finalAttrs.version}/changelog";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
