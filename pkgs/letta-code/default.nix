{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  nodejs,
  gitMinimal,
  ripgrep,
}:

let
  version = "0.34.4";

  src = fetchFromGitHub {
    owner = "letta-ai";
    repo = "letta-code";
    tag = "v${version}";
    hash = "sha256-K0BkfHNj7z+DFGjLLzJ+3tapVpEmyEkA/2wxEX6GGuY=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "letta-code-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      export HOME="$TMPDIR"
      bun install --frozen-lockfile --ignore-scripts --no-progress --linker=hoisted
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-GGclxecZR/HEvLxWkZ8e39cKr6SL9iGLiY1ZbsYzYUk=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "letta-code";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
    nodejs
  ];
  dontConfigure = true;

  CI = "true";

  preBuild = ''
    export HOME="$TMPDIR"
    # `bunx` is unavailable in the sandbox; use the installed TypeScript.
    substituteInPlace build.js \
      --replace-fail 'bunx tsc -p tsconfig.types.json' \
        'node ./node_modules/typescript/bin/tsc -p tsconfig.types.json'
  '';

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    chmod -R u+w .
    bun run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pack_dir="$TMPDIR/package"
    mkdir -p "$pack_dir" "$out/lib/letta-code" "$out/bin"

    npm pack --ignore-scripts --pack-destination "$pack_dir"
    tar -xzf "$pack_dir"/letta-ai-letta-code-*.tgz \
      -C "$out/lib/letta-code" --strip-components=1

    cp -rL node_modules "$out/lib/letta-code/node_modules"

    makeWrapper ${lib.getExe bun} "$out/bin/letta" \
      --add-flags "$out/lib/letta-code/letta.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          ripgrep
        ]
      } \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix LD_LIBRARY_PATH : ${stdenv.cc.cc.lib}/lib
      ''}

    runHook postInstall
  '';

  meta = {
    description = "Memory-first coding agent that learns and evolves across sessions";
    homepage = "https://github.com/letta-ai/letta-code";
    changelog = "https://github.com/letta-ai/letta-code/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "letta";
    platforms = lib.platforms.all;
  };
}
