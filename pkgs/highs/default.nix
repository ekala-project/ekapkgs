{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oSAPwPK/ozwrlcopz8hiicRwruic9VHzYRm7LVFJEIY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  doInstallCheck = true;

  nativeBuildInputs = [
    clang
    cmake
    cmake.configurePhaseHook
  ];


  meta = {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "highs";
  };
})
