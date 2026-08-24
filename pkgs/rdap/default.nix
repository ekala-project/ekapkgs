{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rdap";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LE9cTRXphTt045sCJTv25uVXkomRhhN7YI45OupitGs=";
  };

  vendorHash = "sha256-huy7C24dLuQxXisCHMMRufnfk8aPAE73sj4YrzmxlNA=";

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
    maintainers = [ ];
    mainProgram = "rdap";
  };
})
