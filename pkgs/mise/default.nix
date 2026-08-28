{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.7.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F/hxgkqLk36906uhr56W+4Evwc8WLbYWw8pibGsq3EY=";
  };

  cargoHash = "sha256-W88dlxvDEwN6C1j1WMtL/KodWQZ9UnI1VJc3xp1Lnqw=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  # disable warnings as errors for aws-lc-sys in checkPhase
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  # Many tests require network access or specific env setup
  doCheck = false;

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
