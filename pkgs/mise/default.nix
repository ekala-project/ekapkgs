{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.11.10";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "vfox-v${finalAttrs.version}";
    hash = "sha256-ZFvIMNIqFHYtyZVehxkV2FiAkYac1UL+BjF1G5rvMCM=";
  };

  cargoHash = "sha256-VlI9qAVia1LVLCK9XCCgUv7zzhQAbiP2lZYJigVjAHI=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  # disable warnings as errors for aws-lc-sys in checkPhase
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # Many tests require network access or specific env setup

  postInstall = ''
    installManPage ./man/man1/mise.1

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise

    mkdir -p $out/lib/mise
    touch $out/lib/mise/.disable-self-update
  '';

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "Front-end to your dev env";
    changelog = "https://github.com/jdx/mise/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mise";
  };
})
