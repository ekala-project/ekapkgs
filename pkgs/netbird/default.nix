{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "netbird";
  version = "0.76.3";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ebzv1s1r9RPmaysthlRX6isYWDCpSegnp04QKRaGWs0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-36XD5NxkDoEwfFeZwHmqVJBy2RonaU1g1Sjy8GgZAD4=";

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "client" ];

  tags = [ "production" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/netbirdio/netbird/version.version=${finalAttrs.version}"
    "-X main.builtBy=nix"
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace client/cmd/root.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
    substituteInPlace client/ui/grpc.go \
      --replace-fail 'unix:///var/run/netbird.sock' 'unix:///var/run/netbird/sock'
  '';

  postInstall = ''
    mv $out/bin/client $out/bin/netbird
    installShellCompletion --cmd netbird \
      --bash <($out/bin/netbird completion bash) \
      --fish <($out/bin/netbird completion fish) \
      --zsh <($out/bin/netbird completion zsh)
  '';

  meta = {
    homepage = "https://netbird.io";
    description = "Connect your devices into a single secure private WireGuard-based mesh network";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "netbird";
  };
})
