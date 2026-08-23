{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    tag = "v${version}";
    hash = "sha256-1bUMFxPpb9H/pRdCOX0u8Tn8RPmJElDs7o9t5JtRFuU=";
  };

  cargoHash = "sha256-OmlcPZuQ1RbyFrF5tuztucgtCA544UHJxEaXh/mfSHQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mdbook \
      --bash <($out/bin/mdbook completions bash) \
      --fish <($out/bin/mdbook completions fish) \
      --zsh  <($out/bin/mdbook completions zsh )
  '';

  meta = {
    description = "Create books from MarkDown";
    mainProgram = "mdbook";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
