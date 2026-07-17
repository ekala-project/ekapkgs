{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cli11";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "CLIUtils";
    repo = "CLI11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TcOmx/qUK/w3mO0bDHX+TRxxMwJpaDFQBcpkQj3hz8A=";
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
