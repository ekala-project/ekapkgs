{
  lib,
  fetchurl,
  jq,
  nodejs,
  runCommand,
}:

let
  version = "13.0.2";

  src = runCommand "openspecui-src" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/openspecui/-/openspecui-${version}.tgz";
        hash = "sha256-CV/Pwb6YC31zUtlWgTXQuxXA/bJ1/uRqBV17r6orIOs=";
      }
    } -C $out --strip-components=1
    ${lib.getExe jq} 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "openspecui";
  inherit version src;

  dontNpmBuild = true;

  # Skip install scripts of bundled platform packages (nuget/node-gyp).
  env.npmInstallFlagsArray = "--ignore-scripts";
  env.npmRebuildFlagsArray = "--ignore-scripts";

  # onnxruntime-node's postinstall tries to download native binaries from
  # nuget.org, which fails in the nix sandbox. Rebuild the native addons that
  # actually need a host build.
  buildPhase = ''
    runHook preBuild
    npm rebuild better-sqlite3 sharp @parcel/watcher esbuild protobufjs || true
    runHook postBuild
  '';

  meta = {
    description = "Visual interface for spec-driven development";
    homepage = "https://github.com/jixoai/openspecui";
    changelog = "https://github.com/jixoai/openspecui/releases/tag/v${version}";
    downloadPage = "https://www.npmjs.com/package/openspecui";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "openspecui";
  };
}
