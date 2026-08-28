{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  curl,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zchunk";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = "zchunk";
    rev = finalAttrs.version;
    hash = "sha256-cBOcU8e2AA4NNYe4j6NDqhK+21ZWNBoJMgKEhyJHpi4=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    zstd
  ];

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/zchunk/zchunk";
    description = "File format designed for highly efficient deltas while maintaining good compression";
    license = lib.licenses.bsd2;
    mainProgram = "zck";
    platforms = lib.platforms.unix;
  };
})
