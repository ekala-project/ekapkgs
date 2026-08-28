{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  freetype,
  giflib,
  gtk3,
  lcms2,
  libjpeg,
  libpng,
  libtiff,
  openjpeg,
  gifsicle,
  gettext,
}:

stdenv.mkDerivation {
  pname = "mtPaint";
  version = "3.50.14";

  src = fetchFromGitHub {
    owner = "wjaguar";
    repo = "mtPaint";
    rev = "8304376e8861a8a603371b0f188db30f9cafdc17";
    hash = "sha256-dyBbzEjdgMPlPnjFlJoZOh5qjx/qY94F28jEr2ihLQE=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    freetype
    giflib
    gtk3
    lcms2
    libjpeg
    libpng
    libtiff
    openjpeg
    gifsicle
  ];

  configureFlags = [
    "gtk3"
    "intl"
    "man"
  ];

  meta = {
    description = "Simple GTK painting program";
    homepage = "https://mtpaint.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "mtpaint";
  };
}
