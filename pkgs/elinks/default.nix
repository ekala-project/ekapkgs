{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  bzip2,
  zlib,
  brotli,
  zstd,
  xz,
  openssl,
  autoreconfHook,
  gettext,
  pkg-config,
  libev,
  gpm,
  libidn,
  tre,
  expat,
}:

stdenv.mkDerivation rec {
  pname = "elinks";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "rkd77";
    repo = "elinks";
    rev = "v${version}";
    hash = "sha256-oh9nArQ8dkYL4fLSjnnCHbSnxNxJnQmAWD/6Nu7OiiQ=";
  };

  buildInputs = [
    ncurses
    bzip2
    zlib
    brotli
    zstd
    xz
    openssl
    libidn
    tre
    expat
    libev
    gpm
  ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
  ];

  configureFlags = [
    "--enable-finger"
    "--enable-html-highlight"
    "--enable-gopher"
    "--enable-gemini"
    "--enable-cgi"
    "--enable-bittorrent"
    "--enable-nntp"
    "--enable-256-colors"
    "--enable-true-color"
    "--with-brotli"
    "--with-lzma"
    "--with-libev"
    "--with-terminfo"
    "--without-x"
  ];

  meta = {
    description = "Full-featured text-mode web browser";
    mainProgram = "elinks";
    homepage = "https://github.com/rkd77/elinks";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
