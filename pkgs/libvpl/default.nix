{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  replaceVars,
  addDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvpl";
  version = "2023.4.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libvpl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K2TWk6e0qzxfHWk1eFynCPGleWU0vll6y6Ah4/BOTRw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" false)
    (lib.cmakeBool "BUILD_TOOLS" false)
  ];

  patches = [
    (replaceVars ./opengl-driver-lib.patch {
      inherit (addDriverRunpath) driverLink;
    })
  ];

  doCheck = false;

  meta = {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
