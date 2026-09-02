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
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "HEASARC";
    repo = "cfitsio";
    tag = "cfitsio-${finalAttrs.version}";
    hash = "sha256-k05ylMYf+hsYur3BgNAweMeDc89rsBBtie+P7bd+7qg=";
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
    platforms = lib.platforms.unix;
  };
})
