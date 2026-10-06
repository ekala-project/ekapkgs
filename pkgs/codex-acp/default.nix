{
  lib,
  fetchFromGitHub,
  nodejs,
  makeWrapper,
  codex,
}:

let
  version = "2.1.0";
in
nodejs.buildNpmApplication {
  pname = "codex-acp";
  inherit version;

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    tag = "v${version}";
    hash = "sha256-VdC7g7qkgLnFMtga0uwtNd5ZxsT1xc75GEd++kBZXbA=";
  };

  postInstall = ''
    wrapProgram $out/bin/codex-acp \
      --set-default CODEX_PATH ${lib.getExe codex}
  '';

  meta = {
    description = "ACP-compatible coding agent powered by the Codex App Server";
    homepage = "https://github.com/agentclientprotocol/codex-acp";
    changelog = "https://github.com/agentclientprotocol/codex-acp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "codex-acp";
    platforms = lib.platforms.all;
  };
}
