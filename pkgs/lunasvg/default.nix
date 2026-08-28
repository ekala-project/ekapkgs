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

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_PLUTOVG" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    homepage = "https://github.com/sammycage/lunasvg";
    changelog = "https://github.com/sammycage/lunasvg/releases/tag/v${finalAttrs.version}";
    description = "SVG rendering and manipulation library in C++";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
