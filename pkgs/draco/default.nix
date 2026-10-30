{
  lib,
  callPackage,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  gtest,
  eigen,
  ghc_filesystem ? null,

  withAnimation ? true,
  withTranscoder ? (ghc_filesystem != null),
}:

let
  tinygltf = callPackage ./tinygltf.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "draco";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    tag = finalAttrs.version;
    hash = "sha256-Y1bwBFe3bCklZN2+TBs6mhqDKQjrezMiT5zXlPFuMew=";
  };

  postPatch =
    # Populate third_party dirs so cmake doesn't complain about missing submodules
    lib.optionalString withTranscoder (
      ''
        mkdir -p third_party/tinygltf
        ln -s ${tinygltf}/include/* third_party/tinygltf/
        mkdir -p third_party/filesystem/include
      ''
      + lib.optionalString (ghc_filesystem != null) ''
        ln -s ${ghc_filesystem}/include/ghc third_party/filesystem/include/ghc
      ''
    )
    +
      # ld: unknown option: --start-group
      lib.optionalString stdenv.hostPlatform.isDarwin ''
        substituteInPlace cmake/draco_targets.cmake \
          --replace-fail "^Clang" "^AppleClang"
      '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
    gtest
  ];

  buildInputs = lib.optionals withTranscoder [
    eigen
    ghc_filesystem
    tinygltf
  ];

  cmakeEntries = {
    DRACO_GOOGLETEST_PATH = builtins.toString gtest;
    DRACO_ANIMATION_ENCODING = withAnimation;
    BUILD_SHARED_LIBS = true;
    DRACO_TRANSCODER_SUPPORTED = withTranscoder;
  }
  // lib.optionalAttrs withTranscoder {
    DRACO_EIGEN_PATH = "${eigen}/include/eigen3";
    DRACO_FILESYSTEM_PATH = if ghc_filesystem != null then builtins.toString ghc_filesystem else "";
    DRACO_TINYGLTF_PATH = builtins.toString tinygltf;
  };

  env.CXXFLAGS = toString [
    # error: expected ')' before 'value' in 'explicit GltfValue(uint8_t value)'
    "-include"
    "cstdint"
  ];

  meta = {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    changelog = "https://github.com/google/draco/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
