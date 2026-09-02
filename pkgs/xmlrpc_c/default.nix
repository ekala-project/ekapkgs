{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  curl,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "xmlrpc-c";
  version = "1.60.05";

  src = fetchurl {
    url = "mirror://sourceforge/xmlrpc-c/${pname}-${version}.tgz";
    hash = "sha256-Z9hgBiRZ6ieEwHtNeRMxnZU5+nKfU0N46OQciRjyrfY=";
  };

  postPatch = ''
    rm -rf lib/expat
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    libxml2
  ];

  configureFlags = [
    "--enable-libxml2-backend"
  ];

  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  meta = {
    description = "Lightweight RPC library based on XML and HTTP";
    homepage = "https://xmlrpc-c.sourceforge.net/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
