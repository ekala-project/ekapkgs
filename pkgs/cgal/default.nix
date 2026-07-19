{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "cgal";
  version = "5.6.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    hash = "sha256-RY9g346PHy/a2TyPJOGqj0sJXMYaFPrIG5BoDXMGpC4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    gmp
    mpfr
  ];

  patches = [ ./cgal_path.patch ];

  doCheck = false;

  meta = {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
