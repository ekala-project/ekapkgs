{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchFromGitHub,
  gtest,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sexpp";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "sexpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T1qhwMBbz43URzdKPYMAbLSNrg4EaeKj4f9nqZsXls4=";
  };

  buildInputs = [
    gtest
    zlib
    bzip2
  ];

  cmakeEntries = {
    CMAKE_INSTALL_PREFIX = "${placeholder "out"}";
    BUILD_SHARED_LIBS = true;
    WITH_SEXP_TESTS = true;
    DOWNLOAD_GTEST = false;
    WITH_SEXP_CLI = true;
    WITH_SANITIZERS = false;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  preConfigure = ''
    echo "v${finalAttrs.version}" > version.txt
  '';

  meta = {
    homepage = "https://github.com/rnpgp/sexp";
    description = "S-expressions parser and generator C++ library, fully compliant to [https://people.csail.mit.edu/rivest/Sexp.txt]";
    mainProgram = "sexpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
