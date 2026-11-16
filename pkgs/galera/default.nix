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
  version = "26.4.29";

  src = fetchFromGitHub {
    owner = "codership";
    repo = "galera";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-S9aLFGtZ3zKHbxWFK9BtCGjY9pscZqzFHS/tCIStevU=";
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
