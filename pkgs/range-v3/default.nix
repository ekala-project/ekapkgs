{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "range-v3";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    tag = finalAttrs.version;
    hash = "sha256-bRSX91+ROqG1C3nB9HSQaKgLzOHEFy9mrD2WW3PRBWU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    RANGES_ENABLE_WERROR = false;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
    RANGE_V3_TESTS = false;
  };

  doCheck = !stdenv.hostPlatform.isAarch64;
  checkTarget = "test";

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-std=c++17";
  };

  meta = {
    description = "Experimental range library for C++11/14/17";
    homepage = "https://github.com/ericniebler/range-v3";
    changelog = "https://github.com/ericniebler/range-v3/releases/tag/${finalAttrs.version}";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
  };
})
