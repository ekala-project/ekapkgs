{
  lib,
  stdenv,
  fetchurl,
  SDL,
  SDL_image,
  SDL_ttf,
  installShellFiles,
  fontconfig,
  libpng,
  libtiff,
  libx11,
  lua5_2_compat,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grafx2";
  version = "2.8.3091";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    name = "grafx2-${finalAttrs.version}.tar.gz";
    url = "https://pulkomandy.tk/projects/GrafX2/downloads/65";
    hash = "sha256-KdY7GUhQp/Q7t/ktLPGxI66ZHy2gDAffn2yB5pmcJCM=";
  };

  postPatch = ''
    substituteInPlace misc/unix/grafx2.desktop \
      --replace-fail "Exec=grafx2" "Exec=grafx2-sdl"
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    SDL
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_ttf
    fontconfig
    libpng
    libtiff
    libx11
    lua5_2_compat
    zlib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [ "--directory=src" ];
  installFlags = [
    "--directory=src"
    "PREFIX=$(out)"
  ];

  postInstall = ''
    installManPage misc/unix/grafx2.1
  '';

  meta = {
    homepage = "http://grafx2.eu/";
    description = "Ultimate 256-color painting program";
    license = lib.licenses.gpl2Plus;
    mainProgram = "grafx2-sdl";
    platforms = lib.platforms.unix;
  };
})
