{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.9.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    tag = "v${version}";
    hash = "sha256-OVsvlHtYZhoCtTxdZO6mhVPpIICWEt1Q92Jqrf95jyM=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-4ft5168ru+aGPvZAxASQ4wkjtfNG2e0sNhJTedbiKQA=";

  meta = {
    description = "Superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "tsc";
  };
}
