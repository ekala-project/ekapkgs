{
  lib,
  stdenv,
  fetchurl,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcslib";
  version = "8.9";

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-${finalAttrs.version}.tar.bz2";
    hash = "sha256-gqwJzlCRsL8Gzsj1ze7B2r4dBrpd+3/yvbDBaASIgHs=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-include stdio.h";

  nativeBuildInputs = [ flex ];

  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  postInstall = ''
    rm $out/share/doc/wcslib/wcslib
  '';

  meta = {
    homepage = "https://www.atnf.csiro.au/people/mcalabre/WCS/";
    description = "World Coordinate System library for astronomy";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
})
