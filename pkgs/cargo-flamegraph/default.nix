{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-flamegraph";
  version = "0.6.14";

  src = fetchFromGitHub {
    owner = "flamegraph-rs";
    repo = "flamegraph";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tjphY9qZaKkqrbwm8lszyyIBpaKZx644LudBq81qngU=";
  };

  cargoHash = "sha256-mSItpfrGRFL9L3Rlqsvx+FdYyJL8rcWWS8Abyixto7c=";

  meta = {
    description = "Easy flamegraphs for Rust projects and everything else, without Perl or pipes <3";
    homepage = "https://github.com/flamegraph-rs/flamegraph";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
})
