{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Kamalnrf";
    repo = "claude-plugins";
    rev = "aec166c20dbd7d32e3aa03bd7e19979537539438";
    hash = "sha256-Muj+qaHhNcIJgJAkXSa4ucdlwjR9nF6NwZunSU6Gwew=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "claude-plugins-node_modules";
    inherit version src;
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
    find node_modules -maxdepth 1 -type l -delete
    find node_modules/.bin -xtype l -delete 2>/dev/null || true
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/package.json
      [ -f bun.lock ] && cp bun.lock $out/ || true
      runHook postInstall
    '';
    dontFixup = true;
    outputHash = "sha256-5dRGbVsBQ5ZFjfpg1lxlTSATBLxwaZlQtyUXh+bYOE4=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "claude-plugins";
  inherit version src;
  nativeBuildInputs = [ bun makeWrapper ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    chmod -R u+w .
    patchShebangs node_modules 2>/dev/null || true
    ( cd packages/cli && bun build src/index.ts --outdir=dist --target=node )
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    find node_modules -maxdepth 1 -type l -delete
    find node_modules/.bin -xtype l -delete 2>/dev/null || true
    mkdir -p $out/lib/claude-plugins
    cp -r packages/cli/dist packages/cli/package.json $out/lib/claude-plugins/
    cp -r node_modules $out/lib/claude-plugins/
    makeWrapper ${lib.getExe bun} $out/bin/claude-plugins \
      --add-flags "$out/lib/claude-plugins/dist/index.js"
    runHook postInstall
  '';
  doInstallCheck = false;
  meta = {
    description = "CLI tool for managing Claude Code plugins";
    homepage = "https://github.com/Kamalnrf/claude-plugins";
    changelog = "https://github.com/Kamalnrf/claude-plugins";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "claude-plugins";
    platforms = lib.platforms.all;
  };
}
