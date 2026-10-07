{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "kubescape";
  version = "4.0.15";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = "kubescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4WQvIdUPkiN4buqFDJRzY2CHe6EfJcOv1tT2/IETilE=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-dpci0KYQBuUTgGdQ95rQqahX4TtkycJ3ZcEmQXrCLu0=";

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
    mainProgram = "kubescape";
  };
})
