{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fann";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libfann";
    repo = "fann";
    tag = finalAttrs.version;
    hash = "sha256-3rhtQbYEr7ehohSqxLOvP0Y2gqVgLa8ipq9lLTfQiys=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Fast Artificial Neural Network Library";
    homepage = "http://leenissen.dk/fann/wp/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
