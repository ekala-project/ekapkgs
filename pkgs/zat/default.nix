{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zat";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "bglgwyng";
    repo = "zat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HFFVsfbT5syDxKO8ECPBIHqzJxIKAvp7X7O7Cji2Sxk=";
  };

  cargoHash = "sha256-VSu68KPkoOLyva+A3+TtdTg48xZg0LNenMq+z9xoAVU=";

  # Smoke test: zat has no --version flag, so run it against its own source.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/zat src/main.rs > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Code outline viewer for LLM coding agents, showing exported symbols with line numbers";
    homepage = "https://github.com/bglgwyng/zat";
    changelog = "https://github.com/bglgwyng/zat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "zat";
    platforms = lib.platforms.unix;
  };
})
