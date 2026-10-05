{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meilisearch";
  version = "1.54.3";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-teHqKB4paHcjD/62MWBPjIi5Aw8xsFSC0FU4dEzg+ok=";
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  cargoHash = "sha256-nYRA19K8AglXf5tIxkU/2WipYLqLBy5HxQAGRjunhw8=";

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru = {
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = {
    description = "Powerful, fast, and an easy to use search engine";
    mainProgram = "meilisearch";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
})
