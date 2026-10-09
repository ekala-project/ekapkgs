{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lean-ctx";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "yvgude";
    repo = "lean-ctx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gPRBI807zpEwDUZnk2aSLUWqiv3zpUhr3leHwpUnWak=";
  };

  cargoRoot = "rust";
  buildAndTestSubdir = "rust";
  cargoHash = "sha256-tAE34Nf9Wp7zc8TNHkHWYt4IQFy9qYbAWKzDqMuc/V8=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Context OS for AI development: compression, memory, and routing for LLM context";
    homepage = "https://github.com/yvgude/lean-ctx";
    changelog = "https://github.com/yvgude/lean-ctx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "lean-ctx";
    platforms = lib.platforms.unix;
  };
})
