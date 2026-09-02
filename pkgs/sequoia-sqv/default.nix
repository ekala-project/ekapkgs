{
  lib,
  fetchFromGitLab,
  nettle,
  rustPlatform,
  pkg-config,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sequoia-sqv";
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "sequoia-pgp";
    repo = "sequoia-sqv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z8ZZf5+I8YXR6ugP3EF3zynBicQYKoDfCwWmFfrC8FA=";
  };

  cargoHash = "sha256-fsD5LcJ5JTtZbajjU1yaxUGQ+tJk6tyChSmDtJ6k9Bk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    installShellFiles
  ];

  buildInputs = [
    nettle
  ];

  postInstall = ''
    installManPage target/*/release/build/*/out/man-pages/sqv.1
    installShellCompletion --cmd sqv \
      --zsh target/*/release/build/*/out/shell-completions/_sqv \
      --bash target/*/release/build/*/out/shell-completions/sqv.bash \
      --fish target/*/release/build/*/out/shell-completions/sqv.fish
  '';

  doCheck = true;

  meta = {
    description = "Command-line OpenPGP signature verification tool";
    homepage = "https://docs.sequoia-pgp.org/sqv/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sqv";
  };
})
