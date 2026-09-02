{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  autoreconfHook,
  zlib,
  pcre,
  w3m,
  man,
  openssl,
  brotli,
}:

stdenv.mkDerivation rec {
  pname = "privoxy";
  version = "3.0.34";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/${version}%20%28stable%29/${pname}-${version}-stable-src.tar.gz";
    sha256 = "sha256-5sy8oWVvTmFrRlf4UU4zpw9ml+nXKUNWV3g5Mio8XSw=";
  };

  patches = [
    (fetchpatch {
      url = "https://www.privoxy.org/gitweb/?p=privoxy.git;a=commitdiff_plain;h=19d7684ca10f6c1279568aa19e9a9da2276851f1";
      sha256 = "sha256-bCb0RUVrWeGfqZYFHXDEEx+76xiNyVqehtLvk9C1j+4=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    w3m
    man
  ];

  buildInputs = [
    zlib
    pcre
    openssl
    brotli
  ];

  makeFlags = [ "STRIP=" ];

  configureFlags = [
    "--with-openssl"
    "--with-brotli"
    "--enable-external-filters"
    "--enable-compression"
  ];

  postInstall = ''
    rm -r $out/var
  '';

  meta = {
    description = "Non-caching web proxy with advanced filtering capabilities";
    homepage = "https://www.privoxy.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "privoxy";
  };
}
