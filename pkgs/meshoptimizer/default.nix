{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libwebp,
}:

let
  basis_universal = fetchFromGitHub {
    owner = "zeux";
    repo = "basis_universal";
    rev = "88e813c46b3ff42e56ef947b3fa11eeee7a504b0";
    hash = "sha256-8SQhORPPLBeynlRWjpkXxleo5pgkNmEIjcXbptuo8es=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshoptimizer";
  version = "1.3";
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q4oHUJKifmqrfPB7pixZsJqsABGqD6RYnLt17/OQMME=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeEntries = {
    MESHOPT_BUILD_GLTFPACK = true;
    MESHOPT_GLTFPACK_BASISU_PATH = "${basis_universal}";
    MESHOPT_GLTFPACK_LIBWEBP_PATH = "${libwebp.src}";
  };

  cmakeFlags = lib.optional (!stdenv.hostPlatform.isStatic) "-DMESHOPT_BUILD_SHARED_LIBS:BOOL=ON";
  meta = {
    description = "Mesh optimization library that makes meshes smaller and faster to render";
    homepage = "https://github.com/zeux/meshoptimizer";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "gltfpack";
  };
})
