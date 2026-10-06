{
  lib,
  fetchurl,
  nodejs,
  runCommand,
}:

let
  version = "0.0.6";

  src = runCommand "zaly-src" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@zaly/cli/-/cli-${version}.tgz";
        hash = "sha256-Ay6f+V/sLS5H6bINBfl64iiT36uHPfsJm3xmg4rtDDo=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "zaly";
  npmPackName = "@zaly/cli";
  inherit version src;

  dontNpmBuild = true;

  meta = {
    description = "Hackable terminal coding agent";
    homepage = "https://github.com/folke/zaly";
    downloadPage = "https://www.npmjs.com/package/@zaly/cli";
    changelog = "https://github.com/folke/zaly/releases/tag/cli-v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "zaly";
    platforms = lib.platforms.all;
  };
}
