{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "yaegi";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "traefik";
    repo = "yaegi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jpLx2z65KeCPC4AQgFmUUphmmiT4EeHwrYn3/rD4Rzg=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/yaegi"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Go interpreter";
    mainProgram = "yaegi";
    homepage = "https://github.com/traefik/yaegi";
    changelog = "https://github.com/traefik/yaegi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
  };
})
