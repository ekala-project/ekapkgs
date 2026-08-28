{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "kyverno";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "kyverno";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7uzpUyrqe+nvPp5qI0k7+6uFStr+oJNgEJXsuv+nPLs=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kyverno/kyverno/pkg/version.BuildVersion=v${finalAttrs.version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildHash=${finalAttrs.version}"
    "-X github.com/kyverno/kyverno/pkg/version.BuildTime=1970-01-01_00:00:00"
  ];

  vendorHash = "sha256-oAZG0UThURyQgENhpSX/jxaA36/iRPkbYCGYilhIQpc=";

  subPackages = [ "cmd/cli/kubectl-kyverno" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    # we have no integration between krew and kubectl
    # so better rename binary to kyverno and use as a standalone
    mv $out/bin/kubectl-kyverno $out/bin/kyverno
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kyverno \
      --bash <($out/bin/kyverno completion bash) \
      --zsh <($out/bin/kyverno completion zsh) \
      --fish <($out/bin/kyverno completion fish)
  '';

  meta = {
    description = "Kubernetes Native Policy Management";
    mainProgram = "kyverno";
    homepage = "https://kyverno.io/";
    changelog = "https://github.com/kyverno/kyverno/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
  };
})
