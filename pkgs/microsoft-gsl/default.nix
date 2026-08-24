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
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "GSL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nWPjUPDx6Wp2BkREkZV+Nr9AUeUzpKlQ5c1CPp2Ks+M=";
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
    maintainers = [ ];
  };
})
