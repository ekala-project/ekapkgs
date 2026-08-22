{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libtool,
  ffmpeg-headless ? null, # may fail to build; used only for tests
  hm ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kvazaar";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "ultravideo";
    repo = "kvazaar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Th30XO3m4GVeDvdb/RIwKT6+To9C/YU7y8s8hm7vPi0=";
  };

  postPatch = ''
    substituteInPlace tests/util.sh --replace-fail '../libtool' '${lib.getExe libtool}'
  ''
  + lib.optionalString (hm != null) ''
    substituteInPlace tests/util.sh --replace-fail 'TAppDecoderStatic' '${lib.getExe' hm "TAppDecoder"}'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  nativeCheckInputs = lib.optionals (ffmpeg-headless != null) [
    ffmpeg-headless
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  doCheck = false;

  meta = {
    description = "Open-source HEVC encoder";
    homepage = "https://github.com/ultravideo/kvazaar";
    changelog = "https://github.com/ultravideo/kvazaar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
