{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "netbird";
  version = "0.77.1";

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uGyo2J/3berl6yBCs+Qy0mXKMZNRM8o6gclBeiDxon8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-IGCfMhcrZqHye83zcJuDf1Hyv7X4rKybxWOiyxGuYtY=";

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
    mainProgram = "netbird";
  };
})
