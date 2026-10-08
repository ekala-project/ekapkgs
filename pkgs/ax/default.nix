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
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "yusukebe";
    repo = "ax";
    tag = "v${version}";
    hash = "sha256-2F416Szv3Y5cHUB2yOKYKJeHDp7XChG11Lj/zIXsPKc=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "ax-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --frozen-lockfile \
        --ignore-scripts \
        --linker=isolated \
        --backend=symlink \
        --production \
        --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/package.json
      runHook postInstall
    '';

    outputHash = "sha256-/ux73JAcarBQWz3ofTIfJkH50RFHex+C6qO/4DkTGj8=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "ax";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ax $out/bin
    cp -r src package.json $out/share/ax/
    cp -r ${node_modules}/node_modules $out/share/ax/

    makeWrapper ${lib.getExe bun} $out/bin/ax \
      --add-flags "$out/share/ax/src/index.ts" \
      --set NODE_PATH "$out/share/ax/node_modules"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "The AI-era curl: fetch, discover, extract";
    homepage = "https://github.com/yusukebe/ax";
    changelog = "https://github.com/yusukebe/ax/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ax";
    platforms = lib.platforms.unix;
  };
}
