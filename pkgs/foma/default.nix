{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  pkg-config,
  readline,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "foma";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mhulden";
    repo = "foma";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gIyY0wm9U0eUscX18TmNLFN0+7sX4Ll2vaHstvaFsJA=";
  };

  sourceRoot = "${finalAttrs.src.name}/foma";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    bison
    cmake
    cmake.configurePhaseHook
    flex
    pkg-config
  ];

  buildInputs = [
    readline
    zlib
  ];

  cmakeEntries = {
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Multi-purpose finite-state toolkit designed for applications ranging from natural language processing to research in automata theory";
    homepage = "https://github.com/mhulden/foma";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
