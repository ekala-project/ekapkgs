{
  lib,
  stdenv,
  fetchurl,
  libtool,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dialog";
  version = "1.3-20260107";

  src = fetchurl {
    url = "https://invisible-island.net/archives/dialog/dialog-${finalAttrs.version}.tgz";
    hash = "sha256-eLPdGNleUPC+j5ucHnz/4oyb8c3yDVs+8XJ5xNo1xbU=";
  };

  nativeBuildInputs = [
    libtool
  ];

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  configureFlags = [
    "--disable-rpath-hacks"
    "--with-libtool"
    "--with-libtool-opts=-shared"
    "--with-ncursesw"
  ];

  installTargets = [
    "install-full"
  ];

  meta = {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "dialog";
    platforms = lib.platforms.unix;
  };
})
