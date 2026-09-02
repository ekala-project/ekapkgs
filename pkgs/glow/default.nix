{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "glow";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8E3hDbZlROMPn6F2jx1KMavlBUsCnrpGdJeEaYt5bcU=";
  };

  vendorHash = "sha256-o5Z2ABRw6v4wFXp+KxgdKQn5/Lk5LG73VTiDOA/kBIs=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glow \
      --bash <($out/bin/glow completion bash) \
      --fish <($out/bin/glow completion fish) \
      --zsh <($out/bin/glow completion zsh)
  '';

  meta = {
    description = "Render markdown on the CLI, with pizzazz";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "glow";
  };
})
