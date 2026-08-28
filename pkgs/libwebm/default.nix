{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  isStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwebm";
  version = "1.0.0.32";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libwebm";
    tag = "libwebm-${finalAttrs.version}";
    hash = "sha256-SxDGt7nPVkSxwRF/lMmcch1h+C2Dyh6GZUXoZjnXWb4=";
  };

  patches = [
    # libwebm does not generate cmake exports by default,
    # which are necessary to find and use it as build-dependency
    # in other packages
    ./0001-cmake-exports.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  outputs = [
    "dev"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!isStatic))
  ];

  meta = {
    description = "WebM file parser";
    homepage = "https://www.webmproject.org/code/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
