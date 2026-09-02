{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcue";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lipnitsk";
    repo = "libcue";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZMUUa8CmpFNparPsM/P2yvRto9E85EdTxpID5sKQbNI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    bison
    flex
  ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)' \
        'CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)'
  '';

  doCheck = true;

  meta = {
    description = "CUE Sheet Parser Library";
    homepage = "https://github.com/lipnitsk/libcue";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
