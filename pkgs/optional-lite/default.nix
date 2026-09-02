{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "optional-lite";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "martinmoene";
    repo = "optional-lite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmKuxYc0cpoOtRRb4okJZ8pYPvzQid1iqBctnhGlz6M=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  doCheck = true;

  meta = {
    description = "C++17-like optional, a nullable object for C++98, C++11 and later in a single-file header-only library";
    homepage = "https://github.com/martinmoene/optional-lite";
    changelog = "https://github.com/martinmoene/optional-lite/blob/v${finalAttrs.version}/CHANGES.txt";
    license = lib.licenses.boost;
  };
})
