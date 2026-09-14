{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  fontconfig,
  libjpeg,
  liblo,
  libpng,
  zlib,
  libjack2,
  fltk,
  libXcursor,
  libXfixes,
  libXft,
  libXinerama,
  libXrender,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "new-session-manager";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "new-session-manager";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5G2GlBuKjC/r1SMm78JKia7bMA97YcvUR5l6zBucemw=";
  };

  nativeBuildInputs = [
    fltk
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    fltk
    fontconfig
    libjpeg
    liblo
    libpng
    libjack2
    libXcursor
    libXfixes
    libXft
    libXinerama
    libXrender
    xorg.libX11
    xorg.libXext
    zlib
  ];

  env.NIX_LDFLAGS = "-lX11 -lXext -lXinerama -lXfixes -lXcursor -lXft -lXrender -lfontconfig -ljpeg -lpng -lz";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://new-session-manager.jackaudio.org/";
    description = "Session manager designed for audio applications";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
})
