{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblc3";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "liblc3";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4KsvCQ1JZaj0yCT7En7ZcNk0rA8LyDwwcSga2IoVd6A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    description = "LC3 (Low Complexity Communication Codec) is an efficient low latency audio codec";
    homepage = "https://github.com/google/liblc3";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
