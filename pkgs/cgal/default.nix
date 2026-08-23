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
  version = "6.1.2";

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    hash = "sha256-QEEbl8XGTdwa8dFT1Xo55CTSHpR+7ysZT6BcWosALuo=";
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
