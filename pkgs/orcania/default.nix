{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orcania";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = "orcania";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cz3IE5UrfoWjMxQ/+iR1bLsYxf5DVN+7aJqLBcPjduA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=off" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=constant-conversion"
    ]
  );

  meta = {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    mainProgram = "base64url";
    homepage = "https://github.com/babelouest/orcania";
    license = lib.licenses.lgpl21;
  };
})
