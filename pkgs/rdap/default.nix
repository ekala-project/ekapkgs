{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rdap";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KPI6fiw6idcOQboLkdze4LaDdfELEZKsXJD1ainXLc=";
  };

  vendorHash = "sha256-fuTi0mM3ch8cjt2Pgdz9AEaMj2T0a10cCuiTsaeLP6Q=";

  doCheck = false;

  ldflags = [
    "-s"
    "-X=github.com/openrdap/rdap.version=${finalAttrs.version}"
  ];
  meta = {
    description = "Command line client for the Registration Data Access Protocol (RDAP)";
    homepage = "https://www.openrdap.org/";
    changelog = "https://github.com/openrdap/rdap/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "rdap";
  };
})
