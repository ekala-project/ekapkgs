{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "delve";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H91QnLyqywgoc3zdTaclzzUxVPagNnxLzKub2gnL25w=";
  };

  patches = [
    ./disable-fortify.diff
  ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/dlv" ];

  ldflags = [
    "-s"
    "-w"
  ];

  hardeningDisable = [ "fortify" ];

  preCheck = ''
    XDG_CONFIG_HOME=$(mktemp -d)
  '';

  # Disable tests on Darwin as they require various workarounds.
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    # add symlink for vscode golang extension
    ln $out/bin/dlv $out/bin/dlv-dap

    installShellCompletion --cmd dlv \
      --bash <($out/bin/dlv completion bash) \
      --fish <($out/bin/dlv completion fish) \
      --zsh <($out/bin/dlv completion zsh)
  '';

  meta = {
    description = "Debugger for the Go programming language";
    homepage = "https://github.com/go-delve/delve";
    changelog = "https://github.com/go-delve/delve/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "dlv";
  };
})
