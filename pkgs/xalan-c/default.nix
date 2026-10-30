{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  xercesc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xalan-c";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "xalan-c";
    tag = "Xalan-C_1_12_0";
    hash = "sha256-SAuzDvKYk7d7JGf+HyKwMfrrGLwH975JgCmeNDEBImA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ xercesc ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "XSLT processor for transforming XML documents";
    homepage = "https://xalan.apache.org/xalan-c/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "Xalan";
  };
})
