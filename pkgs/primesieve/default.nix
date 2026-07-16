{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primesieve";
  version = "12.14";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kokJJI1CdmKVEq/d+dRI3Q/n/3CiVdY6FKZFjx/hZpk=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  strictDeps = true;

  meta = {
    homepage = "https://primesieve.org/";
    description = "Fast C/C++ prime number generator";
    changelog = "https://github.com/kimwalisch/primesieve/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    mainProgram = "primesieve";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
