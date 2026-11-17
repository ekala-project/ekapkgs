{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "tenv";
  version = "4.16.9";

  src = fetchFromGitHub {
    owner = "tofuutils";
    repo = "tenv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ypMB9cCqCpqh/8xd/cp38qyGqaIiCYG+2HKqk94mOI=";
  };

  vendorHash = "sha256-HRBkamzY1SPC/Wz+z2aXzwOwniWE90PbIH2GRee3Y3I=";

  excludedPackages = [ "tools" ];

  # Tests disabled for requiring network access to release.hashicorp.com

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tenv \
      --zsh <($out/bin/tenv completion zsh) \
      --bash <($out/bin/tenv completion bash) \
      --fish <($out/bin/tenv completion fish)
  '';

  meta = {
    changelog = "https://github.com/tofuutils/tenv/releases/tag/v${finalAttrs.version}";
    description = "OpenTofu, Terraform, Terragrunt and Atmos version manager written in Go";
    homepage = "https://tofuutils.github.io/tenv";
    license = lib.licenses.asl20;
  };
})
