{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  kubectl ? null,
}:

buildGo126Module (finalAttrs: {
  pname = "k9s";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-70Rfu1BVd/QnwWXRRpwIeZ2UJNWIGixpdiOHo4v7adA=";
  };

  ldflags = [
    "-s"
    "-X github.com/derailed/k9s/cmd.version=${finalAttrs.version}"
    "-X github.com/derailed/k9s/cmd.commit=${finalAttrs.src.rev}"
    "-X github.com/derailed/k9s/cmd.date=1970-01-01T00:00:00Z"
  ];

  tags = [ "netcgo" ];

  proxyVendor = true;

  vendorHash = "sha256-PkYDJK2oGl+siCG9p4R8shC0e5BhGFdJsc+ksL9J5zw=";

  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    # k9s requires a writeable log directory
    # Otherwise an error message is printed
    # into the completion scripts
    export K9S_LOGS_DIR=$(mktemp -d)

    installShellCompletion --cmd k9s \
      --bash <($out/bin/k9s completion bash) \
      --fish <($out/bin/k9s completion fish) \
      --zsh <($out/bin/k9s completion zsh)

    ${lib.optionalString (kubectl != null) ''
      wrapProgram $out/bin/k9s \
        --suffix PATH : "${lib.makeBinPath [ kubectl ]}"
    ''}

    mkdir -p $out/share/k9s/skins
    cp -r $src/skins/* $out/share/k9s/skins/
  '';

  meta = {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    changelog = "https://github.com/derailed/k9s/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "k9s";
    maintainers = [ ];
  };
})
