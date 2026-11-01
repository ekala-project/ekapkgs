{
  stdenv,
  SDL2_image,
  SDL2_ttf,
  SDL2_net,
  fpc,
  ffmpeg,
  libglut,
  lib,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  lua5_1,
  SDL2,
  SDL2_mixer,
  zlib,
  libpng,
  libGL,
  libGLU,
  physfs,
  qt5,
}:

let
  inherit (qt5) qtbase qttools wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hedgewars";
  version = "1.0.3";

  src = fetchurl {
    url = "https://hedgewars.org/download/releases/hedgewars-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xcGHfAuuE1THXSuVJ7b5qfeemZMuXQix9vfeFwgGYTA=";
  };

  patches = [
    (fetchpatch {
      name = "hedgewars-ffmpeg-9.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/hedgewars/-/raw/1b03bb9764d38fa6020552174676a9e024d8b18e/ffmpeg-9.patch?inline=false";
      hash = "sha256-J8W8WvQgcteKoUUVDxBINVhMzmec+UuWWltKZ2aq9Go=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    fpc
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2_ttf
    SDL2_net
    SDL2
    SDL2_mixer
    SDL2_image
    lua5_1
    ffmpeg
    libglut
    physfs
    qtbase
  ];

  cmakeFlags = [
    "-DNOVERSIONINFOUPDATE=ON"
    "-DNOSERVER=ON"
  ];

  env.NIX_LDFLAGS = lib.concatMapStringsSep " " (e: "-rpath ${e}/lib") [
    SDL2.out
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    libGL
    libGLU
    libpng.out
    lua5_1
    physfs
    zlib.out
  ];

  qtWrapperArgs = [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      libGL
      libGLU
      libglut
      physfs
    ])
  ];

  meta = {
    description = "Funny turn-based artillery game, featuring fighting hedgehogs";
    homepage = "https://hedgewars.org/";
    license = with lib.licenses; [
      gpl2Only
      fdl12Only
    ];
    platforms = lib.platforms.linux;
    broken = true; # needs SDL2_net 2.x but corepkgs has 3.x
  };
})
