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
  version = "3.12.6";

  src = fetchFromGitHub {
    owner = "yvgude";
    repo = "lean-ctx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x6ilo6lweJoi8Pkqw7PZ2bPBPomPcDnkM41ZPgmhP/w=";
  };

  cargoRoot = "rust";

  buildAndTestSubdir = "rust";

  cargoHash = "sha256-e/b6z3Zzo72sYAkfN79w/AiXeD3XKhiTQeD0hxyynqs=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
