{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  bun,
  versionCheckHook,
}:

bun.buildPackage {
  pname = "agent-slack";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "stablyai";
    repo = "agent-slack";
    tag = "v0.10.2";
    hash = "sha256-0eeI3Tvb4LWDXkXvvjUQyHB8UkQ/nksFHMBkFx8ZAqI=";
  };

  bunStdenv = stdenvNoCC;
  bunInstallFlags = [ "--production" ];
  node_modulesHash = "sha256-gpTy1hm3aLTR/mqlpTWQr3PCUc7wqkjcxh4PTH1aMcE=";

  bunBuildCommand = ''
    bun build src/index.ts --target=bun --outfile dist/agent-slack.js \
      --define 'AGENT_SLACK_BUILD_VERSION="0.10.2"'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 dist/agent-slack.js $out/lib/agent-slack/agent-slack.js
    makeWrapper ${lib.getExe bun} $out/bin/agent-slack \
      --add-flags "$out/lib/agent-slack/agent-slack.js"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Slack CLI for AI agents";
    homepage = "https://github.com/stablyai/agent-slack";
    changelog = "https://github.com/stablyai/agent-slack/releases/tag/v0.10.2";
    license = lib.licenses.mit;
    mainProgram = "agent-slack";
    platforms = lib.platforms.all;
  };
}
