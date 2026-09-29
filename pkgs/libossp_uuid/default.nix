{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libossp-uuid";
  version = "1.6.2";

  src = fetchurl {
    url = "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-${finalAttrs.version}.tar.gz";
    sha256 = "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0";
  };

  configureFlags = [
    "ac_cv_va_copy=C99"
  ];

  patches = [ ./shtool.patch ];

  meta = {
    description = "OSSP uuid ISO-C and C++ shared library";
    homepage = "http://www.ossp.org/pkg/lib/uuid/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
