{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-tZTbDENMllnYxxbxp9kbPPidgyeyA10/e0Zo3ST9V6w=";
  };

  cargoHash = "sha256-Z8qbuHmXIhCf0+UWwFwlMSy1UzWPvPXLYCHagpUgRlU=";

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    changelog = "https://github.com/terror/just-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    mainProgram = "just-lsp";
  };
})
