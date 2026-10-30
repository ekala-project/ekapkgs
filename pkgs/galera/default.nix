{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  check,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "galera";
  version = "26.4.20";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-R2YQtAuqPkOtcvjS5PPcqAqu153N2+0/WjZt96ZSI1A=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    check
    openssl
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Galera replication plugin for MySQL";
    homepage = "https://galeracluster.com/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
