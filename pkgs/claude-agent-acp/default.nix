{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  claude-code,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "claude-agent-acp";
  version = "0.84.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    tag = "v${version}";
    hash = "sha256-9BbbkvdhWejAfCFvyRnFVMWKcpQ6lWOOBj+KI31ypww=";
  };

  npmDepsHash = "sha256-GQJy5ey+B/ehKqH6M5ts1yuCcpW/dibB+SVyzLhNCHs=";
  makeCacheWritable = true;

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ makeWrapper ];

  # The bundled @anthropic-ai/claude-agent-sdk platform packages ship a
  # prebuilt dynamically linked `claude` binary that is not usable on NixOS;
  # point the adapter at our claude-code package instead.
  postInstall = ''
    chmod +x $out/lib/node_modules/claude-agent-acp/dist/index.js
    patchShebangs $out/lib/node_modules/claude-agent-acp/dist/index.js
    ln -sf $out/lib/node_modules/claude-agent-acp/dist/index.js $out/bin/claude-agent-acp
    wrapProgram $out/bin/claude-agent-acp \
      --set-default CLAUDE_CODE_EXECUTABLE ${lib.getExe claude-code}
  '';

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK (TypeScript)";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    changelog = "https://github.com/agentclientprotocol/claude-agent-acp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "claude-agent-acp";
    platforms = lib.platforms.all;
  };
}
