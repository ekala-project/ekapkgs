{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  rust-jemalloc-sys,
  buildPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ruff";
  version = "0.17.6";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = finalAttrs.version;
    hash = "sha256-tvpUTdMRRWNxuAxCU0rWIU4Lt67+aazmmacKgnB6xKo=";
  };

  cargoBuildFlags = [ "--package=ruff" ];

  cargoHash = "sha256-3Is1vACExGKqqiINJqS324WJNz1NI36G3k9zgV1RrKg=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    rust-jemalloc-sys
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd ruff \
        --bash <(${emulator} $out/bin/ruff generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ruff generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ruff generate-shell-completion zsh)
    ''
  );

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Extremely fast Python linter and code formatter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
  };
})
