{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "spglib";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    rev = "v${version}";
    hash = "sha256-RFvd/j/14YRIcQTpnYPx5edeF3zbHbi90jb32i3ZU/c=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
    gtest
  ];

  cmakeFlags = [ "-DSPGLIB_WITH_Fortran=On" ];

  doCheck = true;

  meta = {
    description = "C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
