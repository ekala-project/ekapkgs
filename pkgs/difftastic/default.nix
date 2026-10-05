{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.71.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-xJdR/t6O8PavCKBiKnueiLR01g7nWGUHp9bcjOuDDA8=";
  };

  cargoHash = "sha256-HEX8njuArbgMQI8yDr66siRB8t+4P2Q7rxHuCeaD9Uw=";

  buildInputs = [ rust-jemalloc-sys ];

  # skip flaky tests
  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "difft";
  };
})
