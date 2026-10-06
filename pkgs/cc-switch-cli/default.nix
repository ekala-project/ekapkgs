{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage {
  pname = "cc-switch-cli";
  version = "5.10.5";

  src = fetchFromGitHub {
    owner = "SaladDay";
    repo = "cc-switch-cli";
    tag = "v5.10.5";
    hash = "sha256-RreuW2hlJFH2ETQPwUOB/DE3CtyK8+sEqjbb5cWbR0g=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-OiK0PN1ILtMzl9+QndPnYa1PdFM2Y3BmE7MYJjAWnDc=";

  # Tests require network access and runtime configuration
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "CLI version of CC Switch - All-in-One Assistant for Claude Code, Codex & Gemini CLI";
    homepage = "https://github.com/SaladDay/cc-switch-cli";
    changelog = "https://github.com/SaladDay/cc-switch-cli/releases/tag/v5.10.5";
    downloadPage = "https://github.com/SaladDay/cc-switch-cli/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "cc-switch";
    platforms = lib.platforms.unix;
  };
}
