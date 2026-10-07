{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  zlib,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iqtree";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "iqtree";
    repo = "iqtree3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aw4NYKfPQmVsnex9IbhEv/xRC+HsbVVXBj3LLHdR/es=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    eigen
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  cmakeEntries = {
    USE_CMAPLE = false;
  };

  meta = {
    homepage = "https://iqtree.github.io/";
    description = "Efficient and versatile phylogenomic software by maximum likelihood";
    mainProgram = "iqtree3";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
})
