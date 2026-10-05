{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "minify";
  version = "2.24.19";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = "minify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hEpFUOBHVePNp9Z3ly12Fw1csCmSf4oEIVjkdBXfx+g=";
  };

  vendorHash = "sha256-Xz9cipwjjbTQoSlw5lBM6tuYEhFxngy4h8VYFyb0k9A=";

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
