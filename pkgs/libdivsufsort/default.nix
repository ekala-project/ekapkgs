{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdivsufsort";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "y-256";
    repo = "libdivsufsort";
    rev = "${finalAttrs.version}";
    hash = "sha256-4p+L1bq9SBgWSHXx+WYWAe60V2g1AN+zlJvC+F367Tk=";
  };

  cmakeEntries = {
    BUILD_DIVSUFSORT64 = true;
    CMAKE_POLICY_VERSION_MINIMUM = "3.10";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    homepage = "https://github.com/y-256/libdivsufsort";
    license = lib.licenses.mit;
    description = "Library to construct the suffix array and the BW transformed string";
    platforms = lib.platforms.unix;
  };
})
