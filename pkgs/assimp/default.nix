{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "assimp";
  version = "6.0.5";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWBi1pl5C76UtPhB6SmFipm9oEdnfhELMT3MqfV6oxg=";
  };

  postPatch = ''
    substituteInPlace test/unit/UnitTestFileGenerator.h \
      --replace-fail 'define TMP_PATH "/var/tmp/"' 'define TMP_PATH "/tmp/"'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    zlib
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  cmakeFlags = [
    (lib.cmakeBool "ASSIMP_BUILD_ASSIMP_TOOLS" true)
    (lib.cmakeBool "ASSIMP_BUILD_TESTS" false)
    (lib.cmakeBool "ASSIMP_WARNINGS_AS_ERRORS" false)
  ];

  meta = {
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
