{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  fftw,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "ngspice";
  version = "44.2";

  src = fetchurl {
    url = "mirror://sourceforge/ngspice/ngspice-${version}.tar.gz";
    hash = "sha256-59rft71UdP0iQJweWmes3sGfd+WX32jhfFVJvBOQ1/0=";
  };

  nativeBuildInputs = [
    flex
    bison
  ];

  buildInputs = [
    fftw
    readline
  ];

  configureFlags = [
    "--with-ngshared"
    "--enable-xspice"
    "--enable-cider"
    "--enable-osdi"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Next Generation Spice (Electronic Circuit Simulator)";
    mainProgram = "ngspice";
    homepage = "http://ngspice.sourceforge.net";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
}
