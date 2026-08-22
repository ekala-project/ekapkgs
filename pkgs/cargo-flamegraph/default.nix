{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  perf ? null,
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

  nativeBuildInputs = [ makeWrapper ];

  postFixup = lib.optionalString (perf != null) ''
    wrapProgram $out/bin/cargo-flamegraph \
      --set-default PERF ${perf}/bin/perf
    wrapProgram $out/bin/flamegraph \
      --set-default PERF ${perf}/bin/perf
  '';

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
