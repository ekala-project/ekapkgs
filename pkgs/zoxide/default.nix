{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  withFzf ? true,
  fzf ? null,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zoxide";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLGjsmljY2UZSWmbRX+Xf5sIgSBrDviKGzXjyGmB+2w=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postPatch = lib.optionalString (withFzf && fzf != null) ''
    substituteInPlace src/util.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoHash = "sha256-5Be/eIMn3JurFIhoPK6B5L054lLPek9CR93zTJzJS6w=";

  postInstall = ''
    installManPage man/man*/*
    installShellCompletion --cmd zoxide \
      --bash contrib/completions/zoxide.bash \
      --fish contrib/completions/zoxide.fish \
      --zsh contrib/completions/_zoxide
  '';

  meta = {
    description = "Fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    changelog = "https://github.com/ajeetdsouza/zoxide/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    mainProgram = "zoxide";
  };
})
