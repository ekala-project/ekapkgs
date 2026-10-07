{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "microsoft-gsl";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XpaDcqmjuYFgHSYqpp3b8VwmN29LloftU/81NNdYefU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [ gtest ];

  env.NIX_CFLAGS_COMPILE = "-std=c++17";

  doCheck = true;

  meta = {
    description = "C++ Core Guideline support library";
    homepage = "https://github.com/Microsoft/GSL";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
