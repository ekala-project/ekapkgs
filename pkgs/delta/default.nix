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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    tag = finalAttrs.version;
    hash = "sha256-p/vYclCifRzk8ockxT5k1zBCBL+eF4oldhD3lTvy2EA=";
  };

  cargoHash = "sha256-YjmYeSRt9X/+PROEGg3pBQ1IRnNuwziZ30bA/nKqbWc=";

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
