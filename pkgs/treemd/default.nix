{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KQN0EGlAn1fA5K9v7NC/c3sAJ4whaJpk+yxkZ6tpr70=";
  };

  cargoHash = "sha256-kT54zKtj2e9/KVuDB9kXenApRiELuNYRILIoOq9aWvk=";

  doInstallCheck = true;

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "treemd";
  };
})
