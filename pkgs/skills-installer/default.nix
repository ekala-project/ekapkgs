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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Kamalnrf";
    repo = "claude-plugins";
    rev = "aec166c20dbd7d32e3aa03bd7e19979537539438";
    hash = "sha256-Muj+qaHhNcIJgJAkXSa4ucdlwjR9nF6NwZunSU6Gwew=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "skills-installer-node_modules";
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
  pname = "skills-installer";
  inherit version src;
  nativeBuildInputs = [ bun makeWrapper ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    chmod -R u+w .
    patchShebangs node_modules 2>/dev/null || true
    ( cd packages/skills-installer && bun build src/cli.ts --outdir=dist --target=node )
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    find node_modules -maxdepth 1 -type l -delete
    find node_modules/.bin -xtype l -delete 2>/dev/null || true
    mkdir -p $out/lib/skills-installer
    cp -r packages/skills-installer/dist packages/skills-installer/package.json $out/lib/skills-installer/
    cp -r node_modules $out/lib/skills-installer/
    makeWrapper ${lib.getExe bun} $out/bin/skills-installer \
      --add-flags "$out/lib/skills-installer/dist/cli.js"
    runHook postInstall
  '';
  doInstallCheck = false;
  meta = {
    description = "Install agent skills across multiple AI coding clients";
    homepage = "https://github.com/Kamalnrf/claude-plugins";
    changelog = "https://github.com/Kamalnrf/claude-plugins";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "skills-installer";
    platforms = lib.platforms.all;
  };
}
