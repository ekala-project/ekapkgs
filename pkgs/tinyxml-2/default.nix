{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyxml2";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "leethomason";
    repo = "tinyxml2";
    rev = finalAttrs.version;
    hash = "sha256-rYVQSvxA0nxlZFHwGcOWkxcXZWEvTxR9P+d8E7CSm6U=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "Simple, small, efficient, C++ XML parser";
    homepage = "https://github.com/leethomason/tinyxml2";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
