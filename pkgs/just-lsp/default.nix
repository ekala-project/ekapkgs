{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.5.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-hTjdHIW9mkUyvUZwHrrmnlmmSHOHFTRP6T3G6U+0Df4=";
  };

  cargoHash = "sha256-gVUecEz9hGGZQfNToM7nR2BKXWklS3N5FalTcoO3txU=";

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    changelog = "https://github.com/terror/just-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = [ ];
    mainProgram = "just-lsp";
  };
})
