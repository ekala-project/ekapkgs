{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gavin-bc";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "gavinhoward";
    repo = "bc";
    rev = finalAttrs.version;
    hash = "sha256-bIQk0HzUzL1Ju4+iDpFj1n+GKCj9a3AUAbYA3yX5TNg=";
  };

  versionCheckProgram = "${placeholder "out"}/bin/bc";
  meta = {
    homepage = "https://github.com/gavinhoward/bc";
    description = "Gavin Howard's BC calculator implementation";
    changelog = "https://github.com/gavinhoward/bc/blob/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
