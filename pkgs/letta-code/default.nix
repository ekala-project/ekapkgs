{
  lib,
  fetchurl,
  nodejs,
  runCommand,
}:

let
  version = "0.34.1";

  src = runCommand "letta-code-src" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-${version}.tgz";
        hash = "sha256-h6dN64qSKM4p6wrIisUQKO1MR9KIQRS1nBb9ir0Pixg=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "letta-code";
  npmPackName = "@letta-ai/letta-code";
  inherit version src;

  dontNpmBuild = true;

  # react peer range upstream is narrower than the locked version.
  env.npmFlagsArray = "--legacy-peer-deps";
  env.npmRebuildFlagsArray = "--ignore-scripts";

  meta = {
    description = "Memory-first coding agent that learns and evolves across sessions";
    homepage = "https://github.com/letta-ai/letta-code";
    downloadPage = "https://www.npmjs.com/package/@letta-ai/letta-code";
    changelog = "https://github.com/letta-ai/letta-code/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "letta";
    platforms = lib.platforms.all;
  };
}
