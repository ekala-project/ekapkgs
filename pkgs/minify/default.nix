{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "minify";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = "minify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ad5FtSuiO5XYNDQzHxKVq5Mje0YQH07DHWpjHjnZlrs=";
  };

  vendorHash = "sha256-enDt9HKngsTFkEjetwGhw1RqqrblQrSSOr0/p3hg83s=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/minify" ];

  postInstall = ''
    installShellCompletion --cmd minify --bash cmd/minify/bash_completion
  '';

  meta = {
    description = "Go minifiers for web formats";
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "minify";
  };
})
