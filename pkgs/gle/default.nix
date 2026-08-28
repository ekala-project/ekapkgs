{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  freeglut,
  libx11,
  libxt,
  libxmu,
  libxi,
  libxext,
  libGL,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "gle";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "linas";
    repo = "glextrusion";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "sha256-yvCu0EOwxOMN6upeHX+C2sIz1YVjjB/320g+Mf24S6g=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libGLU
    libGL
    freeglut
    libx11
    libxt
    libxmu
    libxi
    libxext
  ];

  meta = {
    description = "Tubing and extrusion library";
    homepage = "https://www.linas.org/gle/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
