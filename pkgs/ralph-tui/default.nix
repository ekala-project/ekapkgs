{
  lib,
  fetchFromGitHub,
  bun,
  versionCheckHook,
}:

bun.buildPackage {
  pname = "ralph-tui";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "subsy";
    repo = "ralph-tui";
    tag = "v0.12.0";
    hash = "sha256-FqGniyxbOMMbDN/S0gYcdHiOr+nNQuuBgQ8M7M1UP6k=";
  };

  node_modulesHash = "sha256-iClXVYxu2bKqRtp1VNTTYSsMM77LP+leRPgzX6q0xo4=";

  bunBuildCommand = ''
    bun run build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ralph-tui $out/bin
    cp -r dist node_modules package.json $out/lib/ralph-tui/
    makeWrapper ${lib.getExe bun} $out/bin/ralph-tui \
      --add-flags "run $out/lib/ralph-tui/dist/cli.js"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "AI Agent Loop Orchestrator TUI";
    homepage = "https://github.com/subsy/ralph-tui";
    changelog = "https://github.com/subsy/ralph-tui/releases/tag/v0.12.0";
    license = lib.licenses.mit;
    mainProgram = "ralph-tui";
    platforms = lib.platforms.unix;
  };
}
