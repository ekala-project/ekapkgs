# mold — fast linker for Linux
{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mold";
  version = "2.42.1";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = "mold";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3buWURGv4cnXUArWAjH+0Qwa54EAP//INe+/27Wt1S8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    zlib
    zstd
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
  };

  meta = {
    description = "Fast linker for Linux";
    homepage = "https://github.com/rui314/mold";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mold";
  };
})
