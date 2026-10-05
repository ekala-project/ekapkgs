{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "primesieve";
  version = "12.16";

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+k8L2+A2W5v5QmlzGHdNyEKT16yajl+G8ZkhhS6ivIE=";
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
    platforms = lib.platforms.unix;
  };
})
