{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "double-conversion";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "double-conversion";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gxaPqQ51RyXZaTHkvh4RBpedPopcRiuWDoT+PPbI1uw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  # Case sensitivity issue
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm BUILD
  '';

  meta = {
    description = "Binary-decimal and decimal-binary routines for IEEE doubles";
    homepage = "https://github.com/google/double-conversion";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
