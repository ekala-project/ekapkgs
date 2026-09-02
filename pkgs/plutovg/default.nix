{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fontFaceCache ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutovg";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutovg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JP/nNHszTABIat79vcUqFdtv+/Z13D28aYKEt7BALCw=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "PLUTOVG_DISABLE_FONT_FACE_CACHE_LOAD" (!fontFaceCache))
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    homepage = "https://github.com/sammycage/plutovg/";
    changelog = "https://github.com/sammycage/plutovg/releases/tag/v${finalAttrs.version}";
    description = "Tiny 2D vector graphics library in C";
    license = lib.licenses.mit;
  };
})
