{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "treemd";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Epistates";
    repo = "treemd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-55HsSUYOmnxIoPCZ9hLMg3Tb9ywEnyxzMNjXMg8B4ZQ=";
  };

  cargoHash = "sha256-RW/a4j+sZ4r1RZCJty+IPUPSs4khQuTVrkZ+cWS1hvo=";

  doInstallCheck = true;

  meta = {
    description = "TUI/CLI markdown navigator with tree-based structural navigation";
    homepage = "https://github.com/Epistates/treemd";
    changelog = "https://github.com/Epistates/treemd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "treemd";
    platforms = lib.platforms.unix;
  };
})
