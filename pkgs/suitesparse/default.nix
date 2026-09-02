{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  blas,
  lapack,
  metis,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "suitesparse";
  version = "5.13.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${version}";
    sha256 = "sha256-Anen1YtXsSPhk8DpA4JtADIz9m8oXFl9umlkb4iImf8=";
  };

  buildInputs =
    assert (blas.isILP64 == lapack.isILP64);
    [
      blas
      lapack
      metis
      (lib.getLib gfortran.cc)
      gmp
      mpfr
    ];

  preConfigure = ''
    sed -i "Makefile" -e '/GraphBLAS\|Mongoose/d'
  '';

  makeFlags = [
    "INSTALL=${placeholder "out"}"
    "INSTALL_INCLUDE=${placeholder "dev"}/include"
    "JOBS=$(NIX_BUILD_CORES)"
    "MY_METIS_LIB=-lmetis"
  ]
  ++ lib.optionals blas.isILP64 [
    "CFLAGS=-DBLAS64"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types";
  };

  buildFlags = [
    "library"
  ];

  meta = {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "Suite of sparse matrix algorithms";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
  };
}
