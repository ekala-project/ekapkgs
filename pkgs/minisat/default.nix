{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minisat";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "minisat";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-iny5WPmR28H8/cnSdWCaK7HFB68LOrH9pQCoSK1cbJM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.6 FATAL_ERROR)' \
      'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = [ zlib ];

  meta = {
    description = "Compact and readable SAT solver";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    homepage = "http://minisat.se/";
  };
})
