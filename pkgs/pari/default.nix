{
  lib,
  stdenv,
  fetchurl,
  gmp,
  libX11,
  libpthreadstubs,
  perl,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "pari";
  version = "2.17.2";

  src = fetchurl {
    urls = [
      "https://pari.math.u-bordeaux.fr/pub/pari/unix/${pname}-${version}.tar.gz"
      "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-fTBXj1z5exN6KB9FSNExqvwM3oa8/RDMHhvXKoHmUGE=";
  };

  buildInputs = [
    gmp
    libX11
    libpthreadstubs
    perl
    readline
  ];

  configureScript = "./Configure";
  configureFlags = [
    "--with-gmp=${lib.getDev gmp}"
    "--with-readline=${lib.getDev readline}"
    "--mt=pthread"
  ];

  preConfigure = ''
    export LD=$CC
  '';

  makeFlags = [ "all" ];

  meta = {
    description = "Computer algebra system for high-performance number theory computations";
    homepage = "http://pari.math.u-bordeaux.fr";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gp";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
