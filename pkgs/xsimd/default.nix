{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsimd";
  version = "14.2.0";

  src = fetchFromGitHub {
    owner = "xtensor-stack";
    repo = "xsimd";
    tag = finalAttrs.version;
    hash = "sha256-BTiN4B3//wlB3nmOoluM/7bL7J7YIBp5afih9zUP1yw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    doctest
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
  ];

  doCheck = true;
  checkTarget = "xtest";

  meta = {
    description = "C++ wrappers for SIMD intrinsics";
    homepage = "https://github.com/xtensor-stack/xsimd";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
