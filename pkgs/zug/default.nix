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

  cmakeEntries = {
    zug_BUILD_EXAMPLES = false;
    zug_BUILD_TESTS = false;
  };

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
