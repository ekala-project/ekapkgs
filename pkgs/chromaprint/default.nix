{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ffmpeg,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chromaprint";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = "chromaprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Es903zeZ++9/Xb/npUU3rB0V87DVqwT9uTMbQdSzfJI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    ffmpeg.headless
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  hardeningDisable = [ "trivialautovarinit" ];

  cmakeEntries = {
    BUILD_TOOLS = true;
    BUILD_TESTS = false;
  };

  meta = {
    changelog = "https://github.com/acoustid/chromaprint/releases/tag/v${finalAttrs.version}";
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "fpcalc";
  };
})
