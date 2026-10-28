{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  netcdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcdf-fortran";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf-fortran";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EAfMV2EQf9qlW5HicuCJFxHJ/DbLdpyHu2E8nMV3Xe8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
  ];

  buildInputs = [ netcdf ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Fortran interface for the NetCDF library";
    homepage = "https://github.com/Unidata/netcdf-fortran";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
