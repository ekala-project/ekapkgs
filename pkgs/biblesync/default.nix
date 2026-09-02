{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  libuuid,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "biblesync";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "karlkleinpaste";
    repo = "biblesync";
    tag = finalAttrs.version;
    sha256 = "sha256-8CPP0ndrnJrGhNR7Y3lX3td5jXNE8VuwEiD8C2D4K5I=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [ libuuid ];

  meta = {
    homepage = "https://wiki.crosswire.org/BibleSync";
    description = "Multicast protocol to Bible software shared conavigation";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
  };
})
