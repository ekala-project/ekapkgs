{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
  libpng,
  libGL,
  libGLU,
  freeglut,
}:

stdenv.mkDerivation rec {
  pname = "gl2ps";
  version = "1.4.2";

  src = fetchurl {
    url = "http://geuz.org/gl2ps/src/${pname}-${version}.tgz";
    sha256 = "1sgzv547h7hrskb9qd0x5yp45kmhvibjwj2mfswv95lg070h074d";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    zlib
    libpng
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
    freeglut
  ];

  meta = {
    homepage = "http://geuz.org/gl2ps";
    description = "OpenGL to PostScript printing library";
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl2;
    maintainers = [ ];
  };
}
