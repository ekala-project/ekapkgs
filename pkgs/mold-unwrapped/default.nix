{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  mimalloc,
  ninja,
  onetbb,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mold-unwrapped";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = "mold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PPKYjdU4aLxhGLSZTTZFt06/yVi1cTjJalovr/ohDew=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    onetbb
    zlib
    zstd
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    mimalloc
  ];

  cmakeFlags = [
    "-DMOLD_USE_SYSTEM_MIMALLOC:BOOL=ON"
    "-DMOLD_USE_SYSTEM_TBB:BOOL=ON"
  ];

  meta = {
    description = "Faster drop-in replacement for existing Unix linkers";
    homepage = "https://github.com/rui314/mold";
    changelog = "https://github.com/rui314/mold/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "mold";
  };
})
