{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "upterm";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-73CnLXncbS+TyTF14QX/Zr7XVaQczNmO2POP/ybablk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/owenthereal/upterm/internal/version.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-gBk8Kn5zw/ZyiryvOx1KU4rp5q5XmtCgnidqliUBBVo=";

  subPackages = [
    "cmd/upterm"
    "cmd/uptermd"
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    installShellFiles
  ];

  postInstall = ''
    # force go to build for build arch rather than host arch during cross-compiling
    CGO_ENABLED=0 GOOS= GOARCH= go run cmd/gendoc/main.go
    installManPage etc/man/man*/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in upterm uptermd; do
      installShellCompletion --cmd $cmd \
        --bash <($out/bin/$cmd completion bash) \
        --fish <($out/bin/$cmd completion fish) \
        --zsh <($out/bin/$cmd completion zsh)
    done
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = lib.licenses.asl20;
  };
})
