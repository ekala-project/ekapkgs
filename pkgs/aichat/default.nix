{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aichat";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xgTGii1xGtCc1OLoC53HAtQ+KVZNO1plB2GVtVBBlqs=";
  };

  cargoHash = "sha256-u2JBPm03qvuLEUOEt4YL9O750V2QPgZbxvsvlTQe2nk=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion ./scripts/completions/aichat.{bash,fish,zsh}
  '';

  meta = {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = lib.licenses.mit;
    mainProgram = "aichat";
  };
})
