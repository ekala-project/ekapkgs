{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  cairo,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/plplot/plplot/${finalAttrs.version}%20Source/plplot-${finalAttrs.version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    cairo
    pango
  ];

  cmakeFlags = [
    "-DBUILD_TEST=ON"
  ];

  meta = {
    description = "Cross-platform scientific graphics plotting library";
    mainProgram = "pltek";
    homepage = "https://plplot.org";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
})
