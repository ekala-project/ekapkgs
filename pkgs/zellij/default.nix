{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  curl,
  openssl,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pp++8CTIM4PuAYOjM7GnzU4TXTaw8XuDMow5k/7KQgY=";
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail ', "vendored_curl"' ""
  '';

  cargoHash = "sha256-rCK7FyAUIjUq6dxEw9YBaGm29xYvlYjX0b1xHU03XVU=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    mainProgram = "zellij";
  };
})
