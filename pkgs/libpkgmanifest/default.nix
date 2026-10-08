{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rpm,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpkgmanifest";
  version = "0.6.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libpkgmanifest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sVaFJHM/3ZUnzi09qP5xhIkj/GM0kkWMfOPV5EzILLc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    rpm
    yaml-cpp
  ];

  cmakeEntries = {
    WITH_DOCS = false;
    WITH_PYTHON = false;
    WITH_TESTS = false;
    WITH_CODE_COVERAGE = false;
    CMAKE_INSTALL_INCLUDEDIR = "include";
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Library for working with RPM manifests";
    homepage = "https://github.com/rpm-software-management/libpkgmanifest";
    license = lib.licenses.lgpl21Only;
    mainProgram = "libpkgmanifest";
    platforms = lib.platforms.all;
  };
})
