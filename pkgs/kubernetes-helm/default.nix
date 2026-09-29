# kubernetes-helm — Kubernetes package manager
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-helm";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E1xhKV3ahZ8ahCDalga2XSOiLea0UyC8b1t3Gd4P6xA=";
  };

  vendorHash = "sha256-WxQMzzWcMJJATibiXXSBmCQz8YAlRu/MPGBkQaiHht8=";

  subPackages = [ "cmd/helm" ];

  ldflags = [
    "-s"
    "-w"
    "-X helm.sh/helm/v4/internal/version.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd helm \
      --bash <($out/bin/helm completion bash) \
      --fish <($out/bin/helm completion fish) \
      --zsh <($out/bin/helm completion zsh)
  '';

  meta = {
    description = "Kubernetes package manager";
    homepage = "https://helm.sh/";
    license = lib.licenses.asl20;
    mainProgram = "helm";
  };
})
