{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-gNtaQarclLT4VFESlfkt+5pgX+OPCDCgEeJq+OCEaC8=";
  };

  cargoHash = "sha256-iV0YD/5rJivgOXNEaieiwXrDIwwpMf87HXxCCKNXJDA=";

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    changelog = "https://github.com/terror/just-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    mainProgram = "just-lsp";
  };
})
