{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vale";
  version = "3.15.1";

  subPackages = [ "cmd/vale" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    tag = "v${version}";
    hash = "sha256-zp3yEFtYOMsPh6WqIzDnBSvO4mPAcysPkGSnsM44Z9U=";
  };

  vendorHash = "sha256-OOatkx5c+0VCT1+M/Ra60Ujy/djgQd1f3SIYoh9Mesg=";

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = {
    description = "Syntax-aware linter for prose built with speed and extensibility in mind";
    homepage = "https://vale.sh/";
    mainProgram = "vale";
    license = lib.licenses.mit;
  };
}
