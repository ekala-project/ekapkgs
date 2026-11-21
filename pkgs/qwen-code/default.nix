{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gitMinimal,
  ripgrep,
  pkg-config,
  glib,
  libsecret,
  versionCheckHook,
}:

let
  version = "0.24.1";
  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${version}";
    hash = "sha256-E2MgkOhPIEuJGe/k+sryehlLgW8+0iNKMmIt3KnjwjU=";
  };
in
buildNpmPackage {
  npmDepsFetcherVersion = 2;
  pname = "qwen-code";
  inherit version src;

  npmDepsHash = "sha256-mtwpnyK+os+kldQ6ehTvbDHqeFIKYlJsQR+gfvMvTsM=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    gitMinimal
  ];

  buildInputs = [
    ripgrep
    glib
    libsecret
  ];

  buildPhase = ''
    runHook preBuild

    npm ci --offline --ignore-scripts --cache=$npm_config_cache
    patchShebangs node_modules
    patchShebangs packages/*/node_modules || true

    # patch-package patches the ink dependency's types; run it explicitly
    # because npm lifecycle scripts are skipped for reproducibility.
    if [ -x node_modules/.bin/patch-package ]; then
      patchShebangs node_modules/.bin/patch-package
      node_modules/.bin/patch-package
    fi

    npm run generate
    node scripts/build.js --cli-only
    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/qwen-code
    cp -r dist/* $out/share/qwen-code/
    cp scripts/cli-entry.js $out/share/qwen-code/cli-entry.js
    cp package.json $out/share/qwen-code/package.json
    npm prune --production
    cp -r node_modules $out/share/qwen-code/
    find $out/share/qwen-code/node_modules -type l -delete || true
    patchShebangs $out/share/qwen-code
    ln -s $out/share/qwen-code/cli-entry.js $out/bin/qwen

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command-line AI workflow tool for Qwen3-Coder models";
    homepage = "https://github.com/QwenLM/qwen-code";
    changelog = "https://github.com/QwenLM/qwen-code/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = lib.platforms.all;
    mainProgram = "qwen";
  };
}
