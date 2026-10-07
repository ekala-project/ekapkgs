{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PeuaOoYF2sWttVkQ9fUU0awAFSdaR5vIzCZR8hCMTsA=";
  };

  cargoHash = "sha256-IJpPqCXY93gVD43zDHlr81FlOowTD3lzKbO9KL0GLZU=";

  doInstallCheck = true;

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "treemd";
  };
})
