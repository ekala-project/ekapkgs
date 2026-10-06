{
  lib,
  stdenvNoCC,
  fetchurl,
  bun,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "2.75.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@bitkyc08/opencodex/-/opencodex-${version}.tgz";
    hash = "sha256-uVX2tPxW9umDHUJcajiiRgO1ZH9bx18lKhhf6jUz6DA=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "opencodex-node_modules";
    inherit version;

    src = fetchurl {
      url = "https://registry.npmjs.org/@bitkyc08/opencodex/-/opencodex-${version}.tgz";
      hash = "sha256-uVX2tPxW9umDHUJcajiiRgO1ZH9bx18lKhhf6jUz6DA=";
    };

    sourceRoot = "package";

    nativeBuildInputs = [ bun ];

    postUnpack = ''
      cp ${./bun.lock} "$sourceRoot/bun.lock"
    '';

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
      cp package.json $out/
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-ocGgJYx4d+FZlO8I1EunI1pY1pFIKGDManvLsBfhsLE=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation {
  pname = "opencodex";
  inherit version src;

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/opencodex $out/bin
    # Nix provides bun; drop the npm copy of the runtime.
    rm -rf ${node_modules}/node_modules/.bun/bun@* 2>/dev/null || true
    cp -r bin gui src package.json ${node_modules}/node_modules $out/lib/opencodex/

    makeWrapper ${lib.getExe bun} $out/bin/ocx \
      --add-flags "$out/lib/opencodex/src/cli/index.ts"
    ln -s ocx $out/bin/opencodex

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Universal provider proxy for OpenAI Codex, Claude Code, Claude Desktop & Grok Build";
    homepage = "https://github.com/lidge-jun/opencodex";
    changelog = "https://github.com/lidge-jun/opencodex/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ocx";
    platforms = lib.platforms.all;
  };
}
