{
  lib,
  fetchurl,
  jq,
  nodejs,
  runCommand,
}:

let
  version = "1.73.2";

  src = runCommand "command-code-src" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/command-code/-/command-code-${version}.tgz";
        hash = "sha256-xnMOHLYto5gTP7zD7SXrzCmh5yDRLcXeo2+Mdzi4KUI=";
      }
    } -C $out --strip-components=1
    ${lib.getExe jq} 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "command-code";
  inherit version src;

  # dist/ is a prebuilt bundle.
  dontNpmBuild = true;

  meta = {
    description = "Coding agent that learns your coding taste, for open models";
    homepage = "https://commandcode.ai";
    changelog = "https://github.com/CommandCodeAI/command-code/releases";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "command-code";
    platforms = lib.platforms.all;
  };
}
