{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  freetype,
  fribidi,
  libxext,
  libxft,
  libxpm,
  libxrandr,
  libxrender,
  xorgproto,
  libxinerama,
}:

stdenv.mkDerivation rec {

  pname = "fluxbox";
  version = "1.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/fluxbox/fluxbox-${version}.tar.xz";
    sha256 = "1h1f70y40qd225dqx937vzb4k2cz219agm1zvnjxakn5jkz7b37w";
  };

  patches = [
    (fetchurl {
      name = "gcc-11.patch";
      url = "http://git.fluxbox.org/fluxbox.git/patch/?id=22866c4d30f5b289c429c5ca88d800200db4fc4f";
      sha256 = "1x7126rlmzky51lk370fczssgnjs7i6wgfaikfib9pvn4vv945ai";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freetype
    fribidi
    libxext
    libxft
    libxpm
    libxrandr
    libxrender
    xorgproto
    libxinerama
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-imlib2"
  ];

  preConfigure = ''
    substituteInPlace util/fluxbox-generate_menu.in \
      --subst-var-by PREFIX "$out"
  '';

  meta = {
    description = "Full-featured, light-resource X window manager";
    homepage = "https://fluxbox.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
