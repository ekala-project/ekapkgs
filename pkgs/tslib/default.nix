{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tslib";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "libts";
    repo = "tslib";
    tag = finalAttrs.version;
    hash = "sha256-WrzOTZlceYnFXi5AI5vb+ZDSRoqUDk/yyCdBUWKn0sM=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Touchscreen access library";
    homepage = "http://www.tslib.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
  };
})
