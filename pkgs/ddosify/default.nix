{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "ddosify";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "getanteon";
    repo = "anteon";
    tag = "selfhosted-${finalAttrs.version}";
    hash = "sha256-EPbpBCSaUVVhxGlj7gRqwHLuj5p6563iiARqkEjA6Rk=";
  };

  vendorHash = "sha256-Wg4JzA2aEwNBsDrkauFUb9AS38ITLBGex9QHzDcdpoM=";

  sourceRoot = "${finalAttrs.src.name}/ddosify_engine";

  ldflags = [
    "-s"
    "-w"
    "-X=main.GitVersion=${finalAttrs.version}"
    "-X=main.GitCommit=unknown"
    "-X=main.BuildDate=unknown"
  ];

  doCheck = false;

  meta = {
    description = "High-performance load testing tool, written in Golang";
    homepage = "https://ddosify.com/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    mainProgram = "ddosify";
  };
})
