{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spec-kit";
  version = "1.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${version}";
    hash = "sha256-IkyJBiSa6CyTQpRbsFrsixiz3fwzcLFHw1q5sj6elgM=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    typer
    rich
    httpx
    socksio
    platformdirs
    readchar
    truststore
    pyyaml
    packaging
    pathspec
    json5
  ];

  pythonImportsCheck = [ "specify_cli" ];

  meta = {
    description = "Specify CLI, part of GitHub Spec Kit, for Spec-Driven Development";
    homepage = "https://github.com/github/spec-kit";
    changelog = "https://github.com/github/spec-kit/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "specify";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
