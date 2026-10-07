{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pop";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "pop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3rXpU7R4hV5TOIiUOxBfNXlol0plecnJakBM8fbpHmg=";
  };

  vendorHash = "sha256-rLJyyjRsEnPF4mPqWGxsI/QZWLk0fpYGadjdMAXq9uE=";

  env.GOWORK = "off";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/pop man > pop.1
    installManPage pop.1
    installShellCompletion --cmd pop \
      --bash <($out/bin/pop completion bash) \
      --fish <($out/bin/pop completion fish) \
      --zsh <($out/bin/pop completion zsh)
  '';

  nativeInstallCheckInputs = [
  ];
  doInstallCheck = true;
  meta = {
    description = "Send emails from your terminal";
    homepage = "https://github.com/charmbracelet/pop";
    changelog = "https://github.com/charmbracelet/pop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pop";
  };
})
