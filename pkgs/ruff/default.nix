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
  version = "0.16.10";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    tag = finalAttrs.version;
    hash = "sha256-k06KqlFRQju6bDbZboPaqEqzWY0Fw3BBKmzb8Vk4G24=";
  };

  cargoBuildFlags = [ "--package=ruff" ];

  cargoHash = "sha256-rwI+8VxGo7W5ol6FfhKaxRjogbwx6tcYlHEgEuMJXCs=";

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

  doCheck = false;

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Extremely fast Python linter and code formatter";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ruff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ruff";
  };
})
