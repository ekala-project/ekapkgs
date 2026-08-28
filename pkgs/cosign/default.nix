{
  stdenv,
  lib,
  buildGo126Module,
  fetchFromGitHub,
  pcsclite ? null,
  pkg-config,
  installShellFiles,
  pivKeySupport ? true,
  pkcs11Support ? true,
}:

buildGo126Module (finalAttrs: {
  pname = "cosign";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "cosign";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6YgCEeDwjNNMMh1tE/DUbScR7ZYf+FNMhFs+q7b0MuM=";
  };

  buildInputs = lib.optional (stdenv.hostPlatform.isLinux && pivKeySupport && pcsclite != null) (
    lib.getDev pcsclite
  );

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  vendorHash = "sha256-1ouPW3HBjyTB2qRg7DNNLs5eO8UF1UKJLYPPNfJX4NU=";

  subPackages = [
    "cmd/cosign"
  ];

  tags =
    [ ] ++ lib.optionals pivKeySupport [ "pivkey" ] ++ lib.optionals pkcs11Support [ "pkcs11key" ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${finalAttrs.version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cosign \
      --bash <($out/bin/cosign completion bash) \
      --fish <($out/bin/cosign completion fish) \
      --zsh <($out/bin/cosign completion zsh)
  '';

  meta = {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${finalAttrs.version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    mainProgram = "cosign";
    license = lib.licenses.asl20;
  };
})
