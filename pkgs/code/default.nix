{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  pkg-config,
  openssl,
  testers,
  versionCheckHook,
}:

let
  version = "0.6.196";

  src = fetchFromGitHub {
    owner = "just-every";
    repo = "code";
    tag = "v${version}";
    hash = "sha256-9UCPa5gFVL6KQCKviepn4kGhCBV8RPsWjQekD6JccC8=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code";
  inherit version src;

  cargoHash = "sha256-tvice1qSse6VLnJNzqEBzJsiPqMYJKg3cbu34+0ovxU=";

  sourceRoot = "${finalAttrs.src.name}/code-rs";

  cargoBuildFlags = [
    "--bin"
    "code"
    "--bin"
    "code-tui"
    "--bin"
    "code-exec"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  env.CODE_VERSION = version;

  preBuild = ''
    # Reduce peak memory: codegen-units=1 OOMs on aarch64-linux.
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "fat"' 'lto = false' \
      --replace-fail 'codegen-units = 1' 'codegen-units = 16'
  '';

  doCheck = false;

  postInstall = ''
    ln -s code $out/bin/coder
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd code \
      --bash <($out/bin/code completion bash) \
      --fish <($out/bin/code completion fish) \
      --zsh <($out/bin/code completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Fork of codex. Orchestrate agents from OpenAI, Claude, Gemini or any provider.";
    homepage = "https://github.com/just-every/code/";
    changelog = "https://github.com/just-every/code/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "code";
    platforms = lib.platforms.unix;
  };
})
