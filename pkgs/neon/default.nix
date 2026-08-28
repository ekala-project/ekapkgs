{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  pkg-config,
  zlib,
  openssl,
  bash,
}:

stdenv.mkDerivation rec {
  version = "0.37.1";
  pname = "neon";

  src = fetchurl {
    url = "https://notroj.github.io/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-qZtyYlJaRU0QZc923RckD9gI38TvFWNpkP+DpdDZ50A=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxml2
    openssl
    bash
    zlib
  ];

  configureFlags = [
    "--enable-shared"
    "--with-zlib"
    "--with-ssl"
  ];

  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  meta = {
    description = "HTTP and WebDAV client library";
    mainProgram = "neon-config";
    homepage = "https://notroj.github.io/neon/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
}
