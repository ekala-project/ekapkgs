{
  lib,
  stdenv,
  fetchFromGitHub,
  validatePkgConfig,
  cmake,
  ninja,
  plutovg,
  enableFreetype ? false,
  freetype,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutosvg";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutosvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Fo1B9jH/jjcSkrW5Hm6giIYm7zYh7puFFhC6er7XIM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./0001-Emit-correct-pkg-config-file-if-paths-are-absolute.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    plutovg
  ]
  ++ lib.optional enableFreetype freetype;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "PLUTOSVG_ENABLE_FREETYPE" enableFreetype)
  ];

  meta = {
    homepage = "https://github.com/sammycage/plutosvg";
    changelog = "https://github.com/sammycage/plutosvg/releases/tag/${finalAttrs.src.tag}";
    description = "Tiny SVG rendering library in C";
    license = lib.licenses.mit;
  };
})
