{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viu";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+6oo6cJ0L3XuMWZL/8DEKMk6PI7D5IcfoemqIQiOJto=";
  };

  cargoHash = "sha256-gqMG3ATyGTx54Q43Hquc8A/H8fhdgVP1JLh5FGtWTTU=";

  meta = {
    description = "Command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = lib.licenses.mit;
    mainProgram = "viu";
  };
})
