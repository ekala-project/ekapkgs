{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  npmDepsFetcherVersion = 2;
  pname = "context-hub";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "andrewyng";
    repo = "context-hub";
    tag = "v${version}";
    hash = "sha256-BU6SIt5brANngEqVdquQEA6LZcCSH1PNLg5k2b94naM=";
  };

  npmDepsHash = "sha256-AIjQTnfeXt8ROhHcS2vuYQ2HbXdI/MFa4/wnuQknjKA=";
  makeCacheWritable = true;

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --no-audit --no-fund

    mkdir -p $out/lib/context-hub $out/bin
    cp -r cli node_modules package.json $out/lib/context-hub/
    rm -rf $out/lib/context-hub/cli/{test,tests}

    patchShebangs $out/lib/context-hub/cli/bin/

    ln -s $out/lib/context-hub/cli/bin/chub $out/bin/chub
    ln -s $out/lib/context-hub/cli/bin/chub-mcp $out/bin/chub-mcp

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--cli-version";
  doInstallCheck = true;

  meta = {
    description = "CLI for Context Hub - search and retrieve LLM-optimized docs and skills";
    homepage = "https://github.com/andrewyng/context-hub";
    changelog = "https://github.com/andrewyng/context-hub/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "chub";
    platforms = lib.platforms.all;
  };
}
