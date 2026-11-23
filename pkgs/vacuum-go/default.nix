{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vacuum-go";
  version = "0.42.3";

  src = fetchFromGitHub {
    owner = "daveshanley";
    repo = "vacuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VyqD4NrWG6he+7XjjPYmxecD1T4U32YWXyGQD+CTGq0=";
  };

  vendorHash = "sha256-Vx8PGVQfil8U3wV+XCBmhtpvWWyXomKEibc7PwE0qtc=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  subPackages = [ "./vacuum.go" ];

  meta = {
    description = "World's fastest OpenAPI & Swagger linter";
    homepage = "https://quobix.com/vacuum";
    changelog = "https://github.com/daveshanley/vacuum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vacuum";
  };
})
