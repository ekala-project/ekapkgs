{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  lapack,
  which,
  gfortran,
  blas,
  ctestCheckHook ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrupdate";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mpimd-csc";
    repo = "qrupdate-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d5bc9JJOM3Tn41yZfqq3/rPMqZQxxICJo49oELSwxjc=";
  };

  cmakeFlags =
    assert (blas.isILP64 == lapack.isILP64);
    [
      "-DCMAKE_Fortran_FLAGS=${
        toString (
          [
            "-std=legacy"
          ]
          ++ lib.optionals blas.isILP64 [
            "-fdefault-integer-8"
          ]
        )
      }"
    ];

  postPatch = ''
    sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' -i ./CMakeLists.txt
  '';

  doCheck = true;

  nativeBuildInputs = [
    cmake
    which
    gfortran
  ];

  buildInputs = [
    blas
    lapack
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    "test_tchshx"
  ];

  meta = {
    description = "Library for fast updating of qr and cholesky decompositions";
    homepage = "https://github.com/mpimd-csc/qrupdate-ng";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
