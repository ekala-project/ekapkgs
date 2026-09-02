{
  lib,
  stdenv,
  fetchurl,
  perl,
  pkg-config,
  ncurses,
  libx11,
  file,
  which,
  groff,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vifm";
  version = "0.14.4";

  src = fetchurl {
    url = "https://github.com/vifm/vifm/releases/download/v${finalAttrs.version}/vifm-${finalAttrs.version}.tar.bz2";
    hash = "sha256-QLwy7BDYKa2j0Cl9M81PMCxSC7QxKH1UT8CgWuRf2xs=";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    ncurses
    libx11
    file
    which
    groff
  ];

  postPatch = ''
    patchShebangs --build src/helpztags
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Vi-like file manager";
    mainProgram = "vifm";
    homepage = "https://vifm.info/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
