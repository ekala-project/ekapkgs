{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cilium-cli";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "cilium-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BXhzs5FkLyTQVgRS42RTK2Ww712LgrRm0ChzQ/EbWIY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cilium/cilium/cilium-cli/defaults.CLIVersion=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  meta = {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    homepage = "https://www.cilium.io/";
    changelog = "https://github.com/cilium/cilium-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "cilium";
  };
})
