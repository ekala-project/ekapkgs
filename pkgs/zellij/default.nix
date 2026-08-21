{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  mandown,
  installShellFiles,
  pkg-config,
  curl,
  openssl,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij";
  version = "0.43.1";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pUExOToThqDBrNNKHh8Z+PFkijx22I7gpYXTAywlSxM=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "vendored_curl"' ""
  '';

  cargoHash = "sha256-KWE9K7M2pelow5I2rvEZho9L0kmnSXVLDD9XBpzlEEY=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    mandown
    installShellFiles
    pkg-config
    (lib.getDev curl)
  ];

  buildInputs = [
    curl
    openssl
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    mandown docs/MANPAGE.md > zellij.1
    installManPage zellij.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zellij \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  meta = {
    description = "Terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "zellij";
  };
})
