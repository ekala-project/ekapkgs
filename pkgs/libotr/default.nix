{
  lib,
  stdenv,
  fetchurl,
  libgcrypt,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libotr";
  version = "4.1.1";

  src = fetchurl {
    url = "https://otr.cypherpunks.ca/libotr-${finalAttrs.version}.tar.gz";
    sha256 = "1x8rliydhbibmzwdbyr7pd7n87m2jmxnqkpvaalnf4154hj1hfwb";
  };

  patches = [ ./fix-regtest-client.patch ];

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    libgcrypt # for AM_PATH_LIBGCRYPT m4 macro
  ];

  propagatedBuildInputs = [ libgcrypt ];

  meta = {
    homepage = "http://www.cypherpunks.ca/otr/";
    license = lib.licenses.lgpl21;
    description = "Library for Off-The-Record Messaging";
    platforms = lib.platforms.unix;
  };
})
