{
  lib,
  stdenv,
  fetchurl,
  fontconfig,
  libx11,
  libxinerama,
  libxft,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "dmenu";
  version = "5.3";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/dmenu-${version}.tar.gz";
    sha256 = "sha256-Go9T5v0tdJg57IcMXiez4U2lw+6sv8uUXRWeHVQzeV8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fontconfig
    libx11
    libxinerama
    zlib
    libxft
  ];

  postPatch = ''
    sed -ri -e 's!\<(dmenu|dmenu_path|stest)\>!'"$out/bin"'/&!g' dmenu_run
    sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu_path
  '';

  preConfigure = ''
    makeFlagsArray+=(
      PREFIX="$out"
      CC="$CC"
      INCS="`$PKG_CONFIG --cflags fontconfig x11 xft xinerama`"
      LIBS="`$PKG_CONFIG --libs   fontconfig x11 xft xinerama`"
    )
  '';

  meta = {
    description = "Generic, highly customizable, and efficient menu for the X Window System";
    homepage = "https://tools.suckless.org/dmenu";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "dmenu";
  };
}
