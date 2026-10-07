{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  blas,
  lapack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hmat-oss";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jeromerobert";
    repo = "hmat-oss";
    tag = finalAttrs.version;
    hash = "sha256-GnFlvZCEzSCcBVLjFWLe+AKXVA6UMs/gycrOJ2TBqrE=";
  };

  cmakeEntries = {
    HMAT_GIT_VERSION = false;
    BLA_PREFER_PKGCONFIG = true;
    CBLAS_INCLUDE_DIR = "${lib.getDev blas}/include";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
  ];

  meta = {
    description = "Hierarchical matrix C/C++ library";
    homepage = "https://github.com/jeromerobert/hmat-oss";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
