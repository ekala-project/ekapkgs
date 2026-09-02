{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zug";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "zug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0HrvCpbVnxEvwvG4btXu0hRzdcHsGwM/HUWES/fmxrs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    catch2
  ];

  cmakeFlags = [
    "-Dzug_BUILD_EXAMPLES=OFF"
    "-Dzug_BUILD_TESTS=OFF"
  ];

  preConfigure = ''
    rm BUILD
  '';

  doCheck = false;

  meta = {
    homepage = "https://github.com/arximboldi/zug";
    description = "Library for functional interactive c++ programs";
    license = lib.licenses.boost;
  };
})
