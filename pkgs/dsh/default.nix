{
  lib,
  bashInteractive,
  fetchurl,
  importNpmLock,
  jq,
  makeWrapper,
  nodejs,
  runCommand,
}:

let
  version = "0.2.0-rc.2";

  src = runCommand "dsh-src" { nativeBuildInputs = [ jq ]; } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-${version}.tgz";
        hash = "sha256-vSeEfERc1opWWsH5HAa7vMdjnvkwcfZ4u1nF66/ziFk=";
      }
    } -C $out --strip-components=1
    ${lib.getExe jq} 'del(.devDependencies)' $out/package.json > $out/package.json.tmp
    mv $out/package.json.tmp $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "dsh";
  npmPackName = "@deepseek-ai/dsh";
  inherit version src;
  npmDeps = importNpmLock { npmRoot = ./.; };

  dontNpmBuild = true;

  postInstall = ''
    # /bin/bash does not exist on NixOS. npm may hoist this dep, so locate it.
    while IFS= read -r f; do
      substituteInPlace "$f" --replace-fail '"/bin/bash"' '"${lib.getExe bashInteractive}"'
    done < <(find $out/lib/node_modules -path '*dsh-terminal-bash*/lib/index.js')

    rm -f $out/bin/dsh
    makeWrapper ${lib.getExe nodejs} $out/bin/dsh \
      --argv0 dsh \
      --add-flags "--expose-internals" \
      --add-flags "$out/lib/node_modules/@deepseek-ai/dsh/lib/bin.js"
  '';

  meta = {
    description = "Open-source agent harness developed by DeepSeek AI";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    changelog = "https://github.com/deepseek-ai/deepseek-harness/releases";
    downloadPage = "https://www.npmjs.com/package/@deepseek-ai/dsh";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "dsh";
    platforms = lib.platforms.all;
  };
}
