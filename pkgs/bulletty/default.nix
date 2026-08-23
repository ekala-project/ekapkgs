{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZuNug06zL89D7EWh6UFLiT/Xs/bQOEKY/UiDdkU091M=";
  };

  patches = [
    # Add patch that disables rustfmt to prevent compile time crashes
    ./remove-rustfmt-exec.patch
  ];

  cargoHash = "sha256-fOuUBp5ij0ZqcRhhEIl3pAinsheIHF9VW9Uw3RB4pCI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  checkFlags = [
    # requires network access (CA certificates not available in sandbox)
    "--skip=core::feed::feedparser::tests::get_feed_entries_trims_trailing_response_whitespace"
  ];

  doInstallCheck = true;

  meta = {
    description = "Terminal UI RSS/ATOM feed reader";
    homepage = "https://bulletty.croci.dev";
    changelog = "https://github.com/CrociDB/bulletty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "bulletty";
  };
})
