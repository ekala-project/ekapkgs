{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  jack2,
  libpulseaudio,
  sndio,
  speexdsp,
  validatePkgConfig,
  alsaSupport ? !stdenv.hostPlatform.isDarwin,
  pulseSupport ? !stdenv.hostPlatform.isDarwin,
  jackSupport ? !stdenv.hostPlatform.isDarwin,
  sndioSupport ? !stdenv.hostPlatform.isDarwin,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cubeb";
  version = "0-unstable-2026-09-16";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "e13d9c8855d42bebcd52e69f296404ff437dcdf5";
    hash = "sha256-kCvebRPnbL394Sn/4qTE+8DzPLVH3dvHe6J9r6OGQJ0=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    speexdsp
  ]
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional jackSupport jack2
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional sndioSupport sndio;

  cmakeEntries = {
    BUILD_SHARED_LIBS = enableShared;
    BUILD_TESTS = false;
    BUNDLE_SPEEX = false;
    USE_SANITIZERS = false;
    LAZY_LOAD_LIBS = false;
  };

  meta = {
    description = "Cross platform audio library";
    mainProgram = "cubeb-test";
    homepage = "https://github.com/mozilla/cubeb";
    license = lib.licenses.isc;
    platforms = with lib.platforms; linux ++ darwin;
    pkgConfigModules = [ "libcubeb" ];
  };
})
