{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  stdenv,
  git,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "delta";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    tag = finalAttrs.version;
    hash = "sha256-3xaTEa0M6AZTXtzRcDL743gY4Aws3sJk0Idtw3K+5xw=";
  };

  cargoHash = "sha256-3RfcS7A1RwMwc0inqn4aTpju+cU9u03qAPWzc7iIDTI=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  nativeCheckInputs = [ git ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installShellCompletion --cmd delta \
      --bash <($out/bin/delta --generate-completion bash) \
      --fish <($out/bin/delta --generate-completion zsh) \
      --zsh <($out/bin/delta --generate-completion fish)
  '';

  dontUseCargoParallelTests = true;

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=test_diff_real_files"
  ];

  meta = {
    homepage = "https://github.com/dandavison/delta";
    description = "Syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "delta";
  };
})
