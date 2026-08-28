{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gojq";
  version = "0.12.19";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "gojq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-egaBNHKKzwDwaUN4GT+Xvt11Nz6ojNMSIrXbcEisyI4=";
  };

  vendorHash = "sha256-6UnX9YHh4RGcIFfqaJLxDPxuGQ6KO4UIOryXsoJUjFs=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gojq --zsh _gojq
  '';

  meta = {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    changelog = "https://github.com/itchyny/gojq/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "gojq";
  };
})
