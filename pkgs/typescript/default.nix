{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "typescript";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${version}";
    hash = "sha256-j1AY4sf/Jb6uwOah35lrYooc7BnSeaZ2NO6Fx1zMj60=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-vxILlyVO8S9K+TQPxojaKyV6LptELEyjusMMdr+IVnQ=";

  meta = {
    description = "Superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "tsc";
  };
}
