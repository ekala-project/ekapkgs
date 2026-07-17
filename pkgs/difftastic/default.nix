{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "difftastic";
  version = "0.69.0";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = "difftastic";
    tag = finalAttrs.version;
    hash = "sha256-86aA9B/AaLKhHbaBKL6XpcqocghijCoxyrWUE5YOdaA=";
  };

  cargoHash = "sha256-by/gl6qI6mc93Kxn0BdIhkL/gtoHcGwdzrGiT5KTmP4=";

  buildInputs = [ rust-jemalloc-sys ];

  # skip flaky tests
  checkFlags = [ "--skip=options::tests::test_detect_display_width" ];

  meta = {
    description = "Syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    changelog = "https://github.com/Wilfred/difftastic/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "difft";
  };
})
