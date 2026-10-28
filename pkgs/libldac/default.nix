{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libldac";
  version = "2.0.2.3";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "ldacBT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3gfPvdrtX2yzbXU7/cQNeg5ZrfS9uBPZu0pHQ2xnRlw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "LDAC Bluetooth audio codec library";
    homepage = "https://github.com/EHfive/ldacBT";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
