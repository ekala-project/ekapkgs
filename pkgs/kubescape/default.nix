{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo126Module (finalAttrs: {
  pname = "kubescape";
  version = "4.0.11";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = "kubescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1gaQgn3hLU59hX6GS9KoLcfNqf17wVb8pXP6xHjvCZE=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-vyCj385lt28wApwvKACgVeF7tlJZwRaxlCP2JoDNkro=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
  ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=v${finalAttrs.version}"
    "-X=github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kubescape \
      --bash <($out/bin/kubescape completion bash) \
      --fish <($out/bin/kubescape completion fish) \
      --zsh <($out/bin/kubescape completion zsh)
  '';

  meta = {
    description = "Tool for testing if Kubernetes is deployed securely";
    homepage = "https://github.com/kubescape/kubescape";
    changelog = "https://github.com/kubescape/kubescape/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "kubescape";
  };
})
