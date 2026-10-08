{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "toon-format";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-b47t8qpLjm/5xsrUlydEng+Wdy/vsve4sF2+yO8g19k=";
  };

  cargoHash = "sha256-fp621Aa2EVK9ghxdlJJHGsjzwZi4eAx9Qhh4Y39c9I0=";

  cargoBuildFlags = [
    "--features"
    "cli"
  ];

  doCheck = false;

  meta = {
    description = "Rust implementation of TOON - Token-Oriented Object Notation for LLM prompts";
    homepage = "https://github.com/toon-format/toon-rust";
    changelog = "https://github.com/toon-format/toon-rust/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "toon";
    platforms = lib.platforms.all;
  };
}
