{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  libX11,
  libXi,
  gtk2,
  glib,
  pango,
  atk ? null,
  gdk-pixbuf,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lazarus";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "fpc";
    repo = "Lazarus";
    tag = "lazarus_3_6";
    hash = "sha256-+ANj6rmK9QzgeEcnKOlejNi9FtCdtrHt24LcgszTNUE=";
  };

  nativeBuildInputs = [
    fpc
    pkg-config
  ];

  buildInputs = [
    libX11
    libXi
    gtk2
    glib
    pango
    atk
    gdk-pixbuf
  ];

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "INSTALL_PREFIX=$(out)"
    "INSTALL_DATAROOTDIR=$(out)/share"
    "LAZARUS_INSTALL_DIR=$(out)/share/lazarus"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = false;

  buildFlags = [ "bigide" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/lazarus
  '';

  meta = {
    description = "Lazarus IDE for Free Pascal";
    homepage = "https://www.lazarus-ide.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "lazarus-ide";
  };
})
