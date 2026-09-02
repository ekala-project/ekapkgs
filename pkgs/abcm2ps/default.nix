{
  lib,
  stdenv,
  fetchfossil ? null,
  fetchurl,
  docutils,
  pkg-config,
  freetype,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcm2ps";
  version = "8.14.18";

  src =
    if fetchfossil != null then
      fetchfossil {
        url = "https://chiselapp.com/user/moinejf/repository/abcm2ps";
        rev = "v${finalAttrs.version}";
        hash = "sha256-2nmKjLEZ9dTk+oE16gBm9iheVlLvQFvcdc5FPcxaq6M=";
      }
    else
      fetchurl {
        url = "https://chiselapp.com/user/moinejf/repository/abcm2ps/tarball/v${finalAttrs.version}/abcm2ps-v${finalAttrs.version}.tar.gz";
        hash = "sha256-8f/RTGFBU/4F6LXcnfVfLs89cP6BaltdJ0c3xCgCHks=";
      };

  configureFlags = [
    "--INSTALL=install"
  ];

  nativeBuildInputs = [
    docutils
    pkg-config
  ];

  buildInputs = [
    freetype
    pango
  ];

  meta = {
    homepage = "http://moinejf.free.fr/";
    license = lib.licenses.lgpl3Plus;
    description = "Command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = lib.platforms.unix;
    mainProgram = "abcm2ps";
  };
})
