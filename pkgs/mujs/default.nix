{
  lib,
  stdenv,
  fetchurl,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mujs";
  version = "1.3.6";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${finalAttrs.version}.tar.gz";
    hash = "sha256-fPOl5iLP9BkD7/8DNFGPyUrwYyVnUsOLpGGKUZHkTxg=";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "install-shared" ];

  meta = {
    homepage = "https://mujs.com/";
    description = "Lightweight, embeddable Javascript interpreter";
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
  };
})
