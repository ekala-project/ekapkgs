{
  lib,
  stdenv,
  fetchurl,
  openssl,
  pkg-config,
  readline,
  zlib,
  libidn2,
  gmp,
  libiconv,
  libunistring,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "lftp";
  version = "4.9.3";

  src = fetchurl {
    urls = [
      "https://lftp.yar.ru/ftp/${pname}-${version}.tar.xz"
      "https://ftp.st.ryukoku.ac.jp/pub/network/ftp/lftp/${pname}-${version}.tar.xz"
    ];
    sha256 = "sha256-lucZnXk1vjPPaxFh6VWyqrQKt37N8qGc6k/BGT9Fftw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    readline
    zlib
    libidn2
    gmp
    libiconv
    libunistring
    gettext
  ];

  configureFlags = [
    "--with-openssl"
    "--with-readline=${readline.dev}"
    "--with-zlib=${zlib.dev}"
    "--without-expat"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "File transfer program supporting a number of network protocols";
    homepage = "https://lftp.yar.ru/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
