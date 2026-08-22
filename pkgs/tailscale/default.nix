{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  getent,
  iproute2,
  iptables,
  shadow,
  procps,
}:

buildGo126Module (finalAttrs: {
  pname = "tailscale";
  version = "1.102.2";

  outputs = [
    "out"
    "derper"
  ];

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vqNShvER4jT+8WJCcaSVboXPEP6S3QacmkC39tJkR4g=";
  };

  vendorHash = "sha256-amKkUPszyhG4N5ZtrB01swBACYq76raSS+SQRneLmwc=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/derper"
    "cmd/derpprobe"
    "cmd/tailscaled"
    "cmd/get-authkey"
  ];

  excludedPackages = [
    "tstest/integration"
  ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${finalAttrs.version}"
    "-X tailscale.com/version.shortStamp=${finalAttrs.version}"
  ];

  tags = [
    "ts_include_cli"
  ];

  preBuild = ''
    rm -rf ./tool
  '';

  doCheck = false;

  postInstall =
    ''
      ln -s $out/bin/tailscaled $out/bin/tailscale
      moveToOutput "bin/derper" "$derper"
      moveToOutput "bin/derpprobe" "$derper"
    ''
    + ''
      wrapProgram $out/bin/tailscaled \
        --prefix PATH : ${
          lib.makeBinPath [
            getent
            iproute2
            iptables
            shadow
          ]
        } \
        --suffix PATH : ${lib.makeBinPath [ procps ]}
      sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./cmd/tailscaled/tailscaled.service
      install -D -m0444 -t $out/lib/systemd/system ./cmd/tailscaled/tailscaled.service
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      local INSTALL="$out/bin/tailscale"
      installShellCompletion --cmd tailscale \
        --bash <($out/bin/tailscale completion bash) \
        --fish <($out/bin/tailscale completion fish) \
        --zsh <($out/bin/tailscale completion zsh)
    '';

  meta = {
    homepage = "https://tailscale.com";
    description = "Node agent for Tailscale, a mesh VPN built on WireGuard";
    changelog = "https://tailscale.com/changelog#client";
    license = lib.licenses.bsd3;
    mainProgram = "tailscale";
    maintainers = [ ];
  };
})
