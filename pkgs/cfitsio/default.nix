{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  bzip2,
  curl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cfitsio";
  version = "4.6.4";

  src = fetchFromGitHub {
    owner = "HEASARC";
    repo = "cfitsio";
    tag = "cfitsio-${finalAttrs.version}";
    hash = "sha256-8AFPTr8j8f+x1h78IXOV8GHkDPWvI8w8aRxyke3Dras=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    bzip2
    curl
    zlib
  ];

  cmakeFlags = [
    "-DUSE_PTHREADS=ON"
    "-DTESTS=OFF"
    "-DUTILS=ON"
    "-DUSE_BZIP2=ON"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/";
    description = "Library for reading and writing FITS data files";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
