{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  doxygen,
  freeglut,
  freetype,
  libGL,
  libGLU,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ftgl";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "frankheckenbach";
    repo = "ftgl";
    rev = "v${version}";
    hash = "sha256-6TDNGoMeBLnucmHRgEDIVWcjlJb7N0sTluqBwRMMWn4=";
  };

  patches = [
    ./fix-warnings.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
  ];
  buildInputs = [
    freetype
    libGL
    libGLU
    freeglut
  ];

  postInstall = ''
    install -Dm644 src/FTSize.h src/FTFace.h -t $out/include/FTGL
  '';

  meta = {
    homepage = "https://github.com/frankheckenbach/ftgl";
    description = "Font rendering library for OpenGL applications";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
