{
  stdenv,
  lib,
  fetchurl,
  cmake,
  perl,
  pkg-config,
  gtk3,
  ncurses,
}:

stdenv.mkDerivation rec {
  version = "0.83";
  pname = "putty";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${pname}-${version}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-cYd3wT1j0N/5H+AxYrwqBbTfyLCCdjTNYLUc79/2McY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    perl
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isUnix [
    gtk3
    ncurses
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/putty/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
