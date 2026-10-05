{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pfetch-rs";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = "pfetch-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RrsmCSoiTfdWOL0FLbKR8ZQyLMnEnY5fZ0S4pLbwvWY=";
  };

  cargoHash = "sha256-65v8mNYa+zNbAkCQNWGpb9h0bSi66R4p6cKRZ6/wuaM=";

  meta = {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pfetch";
  };
})
