{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "dgop";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0zWMFcxLZEVPzCRe5yDgPlPHBNgw3MMq78MAUvGNu/4=";
  };

  vendorHash = "sha256-agVGh6togqHNCU7/3xDnmfF6bNlm2TAnXw5JhhUivgs=";

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dgop \
      --bash <($out/bin/dgop completion bash) \
      --fish <($out/bin/dgop completion fish) \
      --zsh <($out/bin/dgop completion zsh)
  '';
  meta = {
    description = "API & CLI for System & Process Monitoring";
    homepage = "https://github.com/AvengeMedia/dgop";
    changelog = "https://github.com/AvengeMedia/dgop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ ];
    mainProgram = "dgop";
    platforms = lib.platforms.unix;
  };
})
