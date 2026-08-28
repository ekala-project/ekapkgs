{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module {
  pname = "yajsv";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "neilpa";
    repo = "yajsv";
    rev = "v1.4.1";
    hash = "sha256-dp7PBN8yR+gPPUWA+ug11dUN7slU6CJAojuxt5eNTxA=";
  };

  vendorHash = "sha256-f45climGKl7HxD+1vz2TGqW/d0dqJ0RfvgJoRRM6lUk=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "Yet Another JSON Schema Validator";
    homepage = "https://github.com/neilpa/yajsv";
    license = lib.licenses.mit;
    mainProgram = "yajsv";
  };
}
