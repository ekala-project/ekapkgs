{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-flamegraph";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XB0/ltiiYZpOlQWoyEPyNFhHqolDgIq0waIjQwT3L88=";
  };

  cargoHash = "sha256-OxPvye1HjcQOazAWn7VIa+twWC7uKXeyXkicPiWVe6I=";

  meta = {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/flamegraph-rs/flamegraph";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
