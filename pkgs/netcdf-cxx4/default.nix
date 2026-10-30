{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  netcdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcdf-cxx4";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf-cxx4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZ6n7dW3l8Kqrk2Xp2mxRTUWWQj0XEd2LDTG9EtrfhY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ netcdf ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "C++ interface for the NetCDF library";
    homepage = "https://github.com/Unidata/netcdf-cxx4";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
