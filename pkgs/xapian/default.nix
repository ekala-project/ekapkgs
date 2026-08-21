{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libuuid,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "xapian";
  version = "1.4.27";

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
    hash = "sha256-vLyZz78WCAEZwlcfwpZ5T1Ob1ULKOSbxfCmZYAgwq2E=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  buildInputs = [
    libuuid
    zlib
  ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  doCheck = true;

  env = {
    AUTOMATED_TESTING = true;
  }
  // lib.optionalAttrs stdenv.hostPlatform.is32bit {
    NIX_CFLAGS_COMPILE = "-fpermissive";
  };

  meta = {
    description = "Search engine library";
    homepage = "https://xapian.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
