{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jql";
  version = "9.0.5";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    tag = "jql-v${finalAttrs.version}";
    hash = "sha256-ZlLvwasBrmuowqyKDQHT9EtB3w8y9DhCfap2gzLgu6g=";
  };

  cargoHash = "sha256-zPiJEcvDxkTcA7H1xwKOxZRowKhOTir/3oBFFuIG4es=";

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
