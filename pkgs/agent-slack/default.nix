{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  makeWrapper,
  versionCheckHook,
}:

let
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "stablyai";
    repo = "agent-slack";
    tag = "v${version}";
    hash = "sha256-0eeI3Tvb4LWDXkXvvjUQyHB8UkQ/nksFHMBkFx8ZAqI=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "agent-slack-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --frozen-lockfile \
        --ignore-scripts \
        --production \
        --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp bun.lock package.json $out/
      runHook postInstall
    '';

    outputHash = "sha256-gpTy1hm3aLTR/mqlpTWQr3PCUc7wqkjcxh4PTH1aMcE=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation {
  pname = "agent-slack";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    bun build src/index.ts --target=bun --outfile dist/agent-slack.js \
      --define 'AGENT_SLACK_BUILD_VERSION="${version}"'
    runHook postBuild
  '';

  doCheck = false;

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
    changelog = "https://github.com/stablyai/agent-slack/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "agent-slack";
    platforms = lib.platforms.all;
  };
}
