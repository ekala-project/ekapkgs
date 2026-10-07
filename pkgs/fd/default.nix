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
  version = "10.5.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X3yrZUBieMO5bauUu2mskfvicLRdQcjbXouFTpz+0eQ=";
  };

  cargoHash = "sha256-5ijtWSsHn7ii8+1njwyvyj387FQkMQALKbixkr/nSkk=";

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
