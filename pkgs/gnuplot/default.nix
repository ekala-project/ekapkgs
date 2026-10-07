{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkg-config,
  texinfo,
  cairo,
  gd,
  pango,
  readline,
  zlib,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "gnuplot";
  version = "6.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${pname}-${version}.tar.gz";
    sha256 = "sha256-cyN/N/AzBtaL+uEzqaUNXpNBOE4ZjVqzfuypq1NN7tg=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    texinfo
  ];

  buildInputs = [
    cairo
    gd
    libpng
    pango
    readline
    zlib
  ];

  configureFlags = [
    "--without-x"
    "--without-qt"
    "--without-aquaterm"
  ];


  meta = {
    homepage = "http://www.gnuplot.info/";
    description = "Portable command-line driven graphing utility for many platforms";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = {
      url = "https://sourceforge.net/p/gnuplot/gnuplot-main/ci/master/tree/Copyright";
    };
    mainProgram = "gnuplot";
  };
}
