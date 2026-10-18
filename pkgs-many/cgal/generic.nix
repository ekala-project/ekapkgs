{
  version,
  src-hash,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgal";
  inherit version;

  src = fetchurl {
    url = "https://github.com/CGAL/cgal/releases/download/v${version}/CGAL-${version}.tar.xz";
    hash = src-hash;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [
    boost
    gmp
    mpfr
  ];

  patches = [ ./cgal_path.patch ];

  doCheck = false;

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.all;
  };
})
