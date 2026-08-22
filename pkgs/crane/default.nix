{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "go-containerregistry";
  version = "0.21.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-containerregistry";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qqtcvpxqvOG+zVGse5vCdxaA8tgH3WrKjfLUTRLxA7s=";
  };
  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/crane"
    "cmd/gcrane"
  ];

  ldflags =
    let
      t = "github.com/google/go-containerregistry";
    in
    [
      "-s"
      "-w"
      "-X ${t}/cmd/crane/cmd.Version=v${finalAttrs.version}"
      "-X ${t}/pkg/v1/remote/transport.Version=${finalAttrs.version}"
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cmd in crane gcrane; do
      installShellCompletion --cmd "$cmd" \
        --bash <($GOPATH/bin/$cmd completion bash) \
        --fish <($GOPATH/bin/$cmd completion fish) \
        --zsh <($GOPATH/bin/$cmd completion zsh)
    done
  '';

  # NOTE: no tests
  doCheck = false;

  meta = {
    description = "Tools for interacting with remote images and registries including crane and gcrane";
    homepage = "https://github.com/google/go-containerregistry";
    license = lib.licenses.asl20;
    mainProgram = "crane";
    maintainers = [ ];
  };
})
