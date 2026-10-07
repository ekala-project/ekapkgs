{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  plutovg ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lunasvg";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "lunasvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSkYkxdV5L31cIJtH6cVfQU2nguA3BPCQXnIMnColek=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    plutovg
  ];

  cmakeEntries = {
    USE_SYSTEM_PLUTOVG = true;
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    homepage = "https://github.com/sammycage/lunasvg";
    changelog = "https://github.com/sammycage/lunasvg/releases/tag/v${finalAttrs.version}";
    description = "SVG rendering and manipulation library in C++";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
