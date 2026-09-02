{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fd";
  version = "10.4.2";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D1FCry69KqXgLxU4rVmgKjkM3JqeBRQDfbp3sJtVAbU=";
  };

  cargoHash = "sha256-nsFtnt8z1qohOtHpLk3cstrVXi/yOMMPCTt/SEEB1F0=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ rust-jemalloc-sys ];

  checkFlags = [
    "--skip=test_owner_current_group"
    "--skip=test_exec_invalid_utf8"
    "--skip=test_invalid_utf8"
  ];

  postInstall = ''
    installManPage doc/fd.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fd \
      --bash <($out/bin/fd --gen-completions bash) \
      --fish <($out/bin/fd --gen-completions fish)
    installShellCompletion --zsh contrib/completion/_fd
  '';

  meta = {
    description = "Simple, fast and user-friendly alternative to find";
    homepage = "https://github.com/sharkdp/fd";
    changelog = "https://github.com/sharkdp/fd/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "fd";
  };
})
