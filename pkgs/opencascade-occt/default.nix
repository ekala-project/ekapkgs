{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  ninja,
  rapidjson,
  tcl,
  tk,
  libGL,
  libGLU,
  libxext,
  libxmu,
  libxi,
}:

stdenv.mkDerivation rec {
  pname = "opencascade-occt";
  version = "7.8.1";
  commit = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    hash = "sha256-AGMZqTLLjXbzJFW/RSTsohAGV8sMxlUmdU/Y2oOzkk8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Open-Cascade-SAS/OCCT/commit/7236e83dcc1e7284e66dc61e612154617ef715d6.diff";
      hash = "sha256-NoC2mE3DG78Y0c9UWonx1vmXoU4g5XxFUT3eVXqLU60=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    tcl
    tk
    libGL
    libGLU
    libxext
    libxmu
    libxi
    rapidjson
  ];

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];
  cmakeFlags = [ "-DUSE_RAPIDJSON=ON" ];

  meta = with lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://www.opencascade.org/";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
