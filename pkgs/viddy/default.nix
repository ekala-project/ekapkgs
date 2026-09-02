{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "viddy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RyPG8OAg3i9N2Fq5Hij48wMvfQuTNmJFpatvB3HbXKg=";
  };

  cargoHash = "sha256-P+TtxV2kuHeBHr8GQeJ0VWPkjimfcAtBUFt0z79ML6A=";

  env = {
    VERGEN_BUILD_DATE = "2026-07-14";
    VERGEN_GIT_DESCRIBE = "Nixpkgs";
  };

  meta = {
    changelog = "https://github.com/sachaos/viddy/releases/tag/v${finalAttrs.version}";
    description = "Modern watch command";
    homepage = "https://github.com/sachaos/viddy";
    license = lib.licenses.mit;
    mainProgram = "viddy";
  };
})
