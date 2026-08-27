{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "dgop";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wH1A4bg7OSD/vb5r0naaT+5x5oy6wwTRh12a60sXPxU=";
  };

  vendorHash = "sha256-M46W8rnexs0GR5hahAqCiAX+bsQEmdwTIccUox+oJas=";

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
