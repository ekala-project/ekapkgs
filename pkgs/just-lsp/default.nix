{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-B9ydV1q73auAVVaW9FyYmgyPncX9OXlE4w1IPst9buU=";
  };

  cargoHash = "sha256-vUILbwu5/EQFG/8GCr3tQtmipGrVVwzgoV1oyDHWx0o=";

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    changelog = "https://github.com/terror/just-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc0;
    maintainers = [ ];
    mainProgram = "just-lsp";
  };
})
