{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samurai";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "samurai";
    rev = finalAttrs.version;
    hash = "sha256-0AKbuoOG1PfH9li57X3FqGVRHlXtcmfweP5zSBks5y8=";
  };

  makeFlags = [
    "DESTDIR="
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Ninja-compatible build tool written in C";
    homepage = "https://github.com/michaelforney/samurai";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "samu";
    platforms = lib.platforms.all;
  };
})
