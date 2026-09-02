{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jnv";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+yntdBXnZEFtDvjXRb/NYKyMFBRL5JJYUz9UTGqCSA=";
  };

  cargoHash = "sha256-Ae+YUtZ/sDBjngxIxYZq5M7edCc8tq1X+7rc3IsJhvc=";

  meta = {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = lib.licenses.mit;
  };
})
