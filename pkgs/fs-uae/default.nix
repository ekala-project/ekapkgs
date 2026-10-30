{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  zip,
  glib,
  gtk3,
  sdl2-compat,
  openal,
  zlib,
  libmpeg2,
  libpng,
  libXi,
  libGLU,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae";
  version = "3.1.66";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = "fs-uae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zPVRPazelmNaxcoCStB0j9b9qwQDTgv3O7Bg3VlW9ys=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    zip
  ];

  buildInputs = [
    glib
    gtk3
    libGL
    libGLU
    libXi
    libmpeg2
    libpng
    openal
    sdl2-compat
    zlib
  ];

  meta = {
    description = "Amiga emulator based on WinUAE";
    homepage = "https://fs-uae.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "fs-uae";
  };
})
