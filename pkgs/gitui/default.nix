{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
  openssl,
  pkg-config,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitui";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "gitui-org";
    repo = "gitui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IyDms4ke5evtSjFZrWEy0AascA0g9rG/a9RjbBNzZwg=";
  };

  cargoHash = "sha256-LMw5TRNe9OK6ygOOMBpniMsmrK8K3qdkQ+SmaLJa+w0=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  postPatch = ''
    rm .cargo/config.toml

    rm build.rs
    substituteInPlace Cargo.toml --replace-fail 'build = "build.rs"' ""
  '';

  env = {
    GITUI_BUILD_NAME = finalAttrs.version;
    OPENSSL_NO_VENDOR = 1;
  };

  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];

  meta = {
    changelog = "https://github.com/gitui-org/gitui/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/gitui-org/gitui";
    license = lib.licenses.mit;
    mainProgram = "gitui";
  };
})
