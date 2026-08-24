{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:
buildGo126Module (finalAttrs: {
  pname = "kubescape";
  version = "4.0.12";

  src = fetchFromGitHub {
    owner = "kubescape";
    repo = "kubescape";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HsWCr+6BldF8l5nA/yWJG15nR+rliW7E+1HtX5Pa9Iw=";
    fetchSubmodules = true;
  };

  proxyVendor = true;
  vendorHash = "sha256-gZD5fvD8EDD30K5C/3ZXul4ZWpfILljyMXD9bVP0Ad8=";

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
