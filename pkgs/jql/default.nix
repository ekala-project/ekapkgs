{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jql";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    tag = "jql-v${finalAttrs.version}";
    hash = "sha256-rGrwph8+A2Fjw7klt5iUIH7mS26/rhu+Yp/63AywQk8=";
  };

  cargoHash = "sha256-Lc6OD/C0ChXR30OQK56yMaEOGa3xAmJ6wAPLGqKmO38=";

  meta = {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "jql";
  };
})
