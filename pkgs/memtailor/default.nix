{
  lib,
  fetchFromGitHub,
  stdenv,
  autoreconfHook,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "memtailor";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "memtailor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cpM/oa4GAKDxs6yrxHngpvam18cGA2u9Ftvd2WW4vdI=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  checkInputs = [
    gtest
  ];

  __structuredAttrs = true;

  strictDeps = true;

  configureFlags = [
    (lib.withFeature finalAttrs.doCheck "gtest")
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "C++ library of special purpose memory allocators";
    homepage = "https://github.com/Macaulay2/memtailor";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
