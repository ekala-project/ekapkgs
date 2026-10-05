{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-swagger";
  version = "0.36.6";

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = "go-swagger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-toW7tpYYioEOTUDH8xVbpNSco303NUO7CpU/GGJKYtI=";
  };

  vendorHash = "sha256-bOtZLwX+m+JukowqWeqayaq+L0TP5PTMyox0AWWysmk=";

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${finalAttrs.version}"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "swagger";
  };
})
