{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "mockgen";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "mock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gYUL+ucnKQncudQDcRt8aDqM7xE5XSKHh4X0qFrvfGs=";
  };

  vendorHash = "sha256-Cf7lKfMuPFT/I1apgChUNNCG2C7SrW7ncF8OusbUs+A=";

  env.CGO_ENABLED = 0;

  subPackages = [ "mockgen" ];

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];
  meta = {
    description = "Mocking framework for the Go programming language";
    homepage = "https://github.com/uber-go/mock";
    changelog = "https://github.com/uber-go/mock/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "mockgen";
  };
})
