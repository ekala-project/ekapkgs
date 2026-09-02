{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  gtest,
  withAnimation ? true,
}:

let
  cmakeBool = b: if b then "ON" else "OFF";
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.5.7";
  pname = "draco";

  src = fetchFromGitHub {
    owner = "google";
    repo = "draco";
    rev = finalAttrs.version;
    hash = "sha256-p0Mn4kGeBBKL7Hoz4IBgb6Go6MdkgE7WZgxAnt1tE/0=";
    fetchSubmodules = true;
  };

  # ld: unknown option: --start-group
  postPatch = ''
    substituteInPlace cmake/draco_targets.cmake \
      --replace "^Clang" "^AppleClang"
  '';

  buildInputs = [ gtest ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    python3
  ];

  cmakeFlags = [
    "-DDRACO_ANIMATION_ENCODING=${cmakeBool withAnimation}"
    "-DDRACO_GOOGLETEST_PATH=${gtest}"
    "-DBUILD_SHARED_LIBS=${cmakeBool true}"
    "-DDRACO_TRANSCODER_SUPPORTED=OFF"
  ];

  meta = with lib; {
    description = "Library for compressing and decompressing 3D geometric meshes and point clouds";
    homepage = "https://google.github.io/draco/";
    changelog = "https://github.com/google/draco/releases/tag/${finalAttrs.version}";
    license = licenses.asl20;
    platforms = platforms.all;
  };
})
