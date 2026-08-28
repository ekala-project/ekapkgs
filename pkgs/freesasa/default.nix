{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  libtool,
  pkg-config,
  libxml2,
  json_c,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freesasa";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "mittinatten";
    repo = "freesasa";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-lHFA/cG7PgUixGvnrOsaVNOqWyYrKkbqmpu+inB6We4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  buildInputs = [
    json_c
    libxml2
  ];

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "C-library for calculating Solvent Accessible Surface Areas";
    homepage = "https://github.com/mittinatten/freesasa";
    changelog = "https://github.com/mittinatten/freesasa/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "freesasa";
    platforms = lib.platforms.unix;
  };
})
