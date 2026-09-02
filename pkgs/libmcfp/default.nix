{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmcfp";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libmcfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T9zqcx207L/AhMjpvv/3wdB20odLYV4I8Th49tpOetA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Header only library that can collect configuration options from command line arguments";
    homepage = "https://github.com/mhekkel/libmcfp";
    changelog = "https://github.com/mhekkel/libmcfp/blob/${finalAttrs.src.rev}/changelog";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
