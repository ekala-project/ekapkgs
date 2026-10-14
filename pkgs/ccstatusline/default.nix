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
  version = "2.2.30";

  src = fetchFromGitHub {
    owner = "sirmalloc";
    repo = "ccstatusline";
    tag = "v${version}";
    hash = "sha256-5WteIWSlrPJjIcrkfUwV1Xpl+lhutW9ZwMeejq6TD0s=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "ccstatusline-node_modules";
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
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/package.json
      [ -f bun.lock ] && cp bun.lock $out/ || true
      runHook postInstall
    '';
    dontFixup = true;
    outputHash = "sha256-WwYBXa0qP8f4QbAQB9rGvUi6tJTeKsQHXrNI7PytZa8=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "ccstatusline";
  inherit version src;
  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    chmod -R u+w .
    patchShebangs node_modules 2>/dev/null || true
    bun build src/ccstatusline.ts --target=node --splitting --format=esm --outdir=dist --target-version=14
    bun run scripts/replace-version.ts || true
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ccstatusline
    cp -r dist package.json $out/lib/ccstatusline/
    makeWrapper ${lib.getExe bun} $out/bin/ccstatusline \
      --add-flags "$out/lib/ccstatusline/dist/ccstatusline.js"
    runHook postInstall
  '';
  doInstallCheck = false;
  meta = {
    description = "Customizable status line formatter for the Claude Code CLI";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    changelog = "https://github.com/sirmalloc/ccstatusline/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "ccstatusline";
    platforms = lib.platforms.unix;
  };
}
