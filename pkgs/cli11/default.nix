{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cli11";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lFMv7WH/Gv+lRjs9tH6QYk+E/QC39ndzvtYKwpGNkmg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  doCheck = false;

  meta = {
    description = "Command line parser for C++11";
    homepage = "https://github.com/CLIUtils/CLI11";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.bsd3;
  };
})
