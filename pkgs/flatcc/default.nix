{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatcc";
  version = "0.6.4";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J3vw7DYhaYD7QVChcNElKCYoh0cwGJj2hr5ugcIcZZw=";
  };

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ];

  cmakeEntries = {
    FLATCC_INSTALL = true;
  };
  doInstallCheck = true;

  meta = {
    description = "FlatBuffers Compiler and Library in C for C";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    changelog = "https://github.com/dvidelabs/flatcc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
  };
})
