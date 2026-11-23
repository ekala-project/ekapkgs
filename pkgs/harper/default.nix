{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harper";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K8vtXq3Zf7PKsFZoErXA6zs5yIhqlzFk1E9W0dLrcC0=";
  };

  cargoHash = "sha256-xL6O9bWa4YjepFD9moXqQveF8QqQzYzHqc/Z36S1Fag=";

  cargoBuildFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  cargoTestFlags = [
    "--package=harper-cli"
    "--package=harper-ls"
  ];

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "harper-ls";
  };
})
