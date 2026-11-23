{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cc-switch-cli";
  version = "5.11.4";

  src = fetchFromGitHub {
    owner = "SaladDay";
    repo = "cc-switch-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qrkvHhvKLQVkCfcwsHr/IPPXL9Jp7fFjR6oel65K/Do=";
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-2shi1FVCTmVY/9oJuXWj9QX/ATGG9Fs4T1TmNLMgb8o=";

  # Tests require network access and runtime configuration

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "CLI version of CC Switch - All-in-One Assistant for Claude Code, Codex & Gemini CLI";
    homepage = "https://github.com/SaladDay/cc-switch-cli";
    changelog = "https://github.com/SaladDay/cc-switch-cli/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/SaladDay/cc-switch-cli/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "cc-switch";
    platforms = lib.platforms.unix;
  };
})
