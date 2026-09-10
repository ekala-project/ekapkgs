{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  git,
  nix-prefetch-git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npins";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    rev = "e818ca8833f1d92fda553fe91b2f02999ff9a511";
    hash = "sha256-PRdGQlxpv8qXdQ6KwlP2Ky2HBHDY83lGTSiD6yljUxE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-compat-0.1.0" = "sha256-b1EuVuU7HEwfoSfTNvw1F+geJjUe2erM+0Dajc9pono=";
    };
  };

  cargoBuildFlags = [
    "-p"
    "npins"
    "-p"
    "npins-completions"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # Almost all tests require internet.
  doCheck = false;

  postFixup = ''
    installShellCompletion --cmd npins \
      --bash <($out/bin/npins-completions bash) \
      --fish <(cat <($out/bin/npins-completions fish) $src/completions/pin-completions.fish) \
      --zsh <($out/bin/npins-completions zsh)

    rm $out/bin/npins-completions

    wrapProgram $out/bin/npins --prefix PATH : ${
      lib.makeBinPath [
        git
        nix-prefetch-git
      ]
    }
  '';

  meta = {
    description = "Nix dependency pinning that does not use IFD";
    homepage = "https://github.com/andir/npins";
    license = lib.licenses.eupl12;
    mainProgram = "npins";
    platforms = lib.platforms.all;
  };
})
