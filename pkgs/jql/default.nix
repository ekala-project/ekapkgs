{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jql";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    tag = "jql-v${finalAttrs.version}";
    hash = "sha256-zmeewj6ToDV2oQw82JU4wXPVhlF+HhUHOcZeM58Sfzw=";
  };

  cargoHash = "sha256-PVboGsE8ucpTlNqF/7aD2UaxbzFQPPh3+Eo1shRWNeA=";

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
