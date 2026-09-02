{
  lib,
  stdenv,
  fetchurl,
  expat,
  zlib,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exempi";
  version = "2.6.6";

  src = fetchurl {
    url = "https://libopenraw.freedesktop.org/download/exempi-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-dRO35Cw72QpY132TjGDS6Hxo+BZG58uLEtcf4zQ5HG8=";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--enable-unittest=no"
  ];

  buildInputs = [
    expat
    zlib
    boost
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Implementation of XMP (Adobe's Extensible Metadata Platform)";
    mainProgram = "exempi";
    homepage = "https://libopenraw.freedesktop.org/exempi/";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
})
