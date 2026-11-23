{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-outdated";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFl0InY6KJhnMNdYlaVqsNt0zGi/jk/bO09X4LwXReY=";
  };

  cargoHash = "sha256-LdmGQGRiRBYveyOw0ljHVffhyX1bhnKCLxcIZrbacds=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
  };
})
