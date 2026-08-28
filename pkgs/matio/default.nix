{
  lib,
  stdenv,
  fetchurl,
  hdf5,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matio";
  version = "1.5.30";

  src = fetchurl {
    url = "mirror://sourceforge/matio/matio-${finalAttrs.version}.tar.gz";
    hash = "sha256-i9O5R3BC7MAN1xwEdi+lhGjhTMzDL9jGgmwtoei8MQc=";
  };

  configureFlags = [ "ac_cv_va_copy=1" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    hdf5
    zlib
  ];

  meta = {
    description = "C library for reading and writing Matlab MAT files";
    homepage = "https://matio.sourceforge.net/";
    license = lib.licenses.bsd2;
    mainProgram = "matdump";
    platforms = lib.platforms.all;
  };
})
