{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ffmpeg-headless,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chromaprint";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "acoustid";
    repo = "chromaprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3HIMgbjaAXsC+8nt7mkj58xA62qwA8FC+PfTGblhNg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/782ef6bb5f6498e35f8e275f76998fbd5ffa36d6.patch";
      hash = "sha256-drUfAMzTrqqB5UbzOnfPq6XD3HI+3sxyJJSTCa0BmD8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    ffmpeg-headless
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  hardeningDisable = [ "trivialautovarinit" ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TOOLS" true)
    (lib.cmakeBool "BUILD_TESTS" false)
  ];

  meta = {
    changelog = "https://github.com/acoustid/chromaprint/releases/tag/v${finalAttrs.version}";
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    mainProgram = "fpcalc";
    maintainers = [ ];
  };
})
