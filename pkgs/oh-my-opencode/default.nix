{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs,
  makeWrapper,
  autoPatchelfHook,
  libxcb,
  versionCheckHook,
}:

let
  version = "5.0.0-beta.86";

  src = fetchFromGitHub {
    owner = "code-yeongyu";
    repo = "oh-my-openagent";
    tag = "v${version}";
    hash = "sha256-R8MMIfLGTr6eecDV7Ue1GOmIyi9V3ErHhdAaitYpxCQ=";
    fetchSubmodules = true;
  };

  koffiPlatform =
    if stdenv.hostPlatform.isDarwin then
      "darwin_${if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"}"
    else
      "linux_${if stdenv.hostPlatform.isAarch64 then "arm64" else "x64"}";

  node_modules = stdenv.mkDerivation {
    pname = "oh-my-opencode-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    # bun.lock does not record workspace lifecycle scripts; bun >= 1.4 treats
    # a workspace that has one as changed and re-fetches manifests, which
    # fails offline.
    postPatch = ''
      substituteInPlace packages/omo-native/package.json \
        --replace-fail '"postinstall": "node bin/senpi-patch.mjs"' ""
    '';

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
    outputHash = "sha256-swYXZvJRKRyc2YshM2TO3gU7s1foI7eBEl/MOW09+hI=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "oh-my-opencode";
  inherit version src;

  nativeBuildInputs = [
    bun
    nodejs
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    libxcb
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libc.musl-aarch64.so.1"
  ];

  postPatch = ''
    substituteInPlace packages/omo-native/package.json \
      --replace-fail '"postinstall": "node bin/senpi-patch.mjs"' ""
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -r ${node_modules}/node_modules .
    chmod -R u+w node_modules
    patchShebangs . || true

    bun build packages/omo-opencode/src/index.ts --outdir dist --target bun --format esm --external zod
    bun build packages/omo-opencode/src/cli/index.ts --outdir dist/cli --target bun --format esm

    bun packages/shared-skills/scripts/materialize-frontend-refs.mjs --strict
    rm -rf dist/skills
    cp -R packages/shared-skills/skills dist/skills

    bun run build:schema || true

    bun run --cwd packages/git-bash-mcp build
    bun build packages/lsp-daemon/src/cli.ts --outdir packages/lsp-daemon/dist --target node --format esm
    node packages/lsp-daemon/scripts/stamp-dist-version.mjs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/oh-my-opencode $out/bin

    cp -r dist node_modules package.json $out/lib/oh-my-opencode/

    mkdir -p $out/lib/oh-my-opencode/packages
    cp -r packages/{git-bash-mcp,lsp-daemon,shared-skills} $out/lib/oh-my-opencode/packages/

    rm -rf $out/lib/oh-my-opencode/packages/git-bash-mcp/node_modules
    rm -rf $out/lib/oh-my-opencode/packages/lsp-daemon/node_modules

    find $out/lib/oh-my-opencode/node_modules/@oh-my-opencode -xtype l -delete 2>/dev/null || true
    rmdir $out/lib/oh-my-opencode/node_modules/@oh-my-opencode 2>/dev/null || true

    for dir in $out/lib/oh-my-opencode/node_modules/.bun/koffi@*/node_modules/koffi/build/koffi/*; do
      [ "$(basename "$dir")" = "${koffiPlatform}" ] || rm -rf "$dir"
    done

    makeWrapper ${bun}/bin/bun $out/bin/oh-my-opencode \
      --add-flags "run $out/lib/oh-my-opencode/dist/cli/index.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    ${bun}/bin/bun -e "await import('$out/lib/oh-my-opencode/dist/index.js'); console.log('ok')"
    runHook postInstallCheck
  '';

  meta = {
    description = "The Best AI Agent Harness - Multi-Model Orchestration for OpenCode";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    changelog = "https://github.com/code-yeongyu/oh-my-openagent/releases/tag/v${version}";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "oh-my-opencode";
    platforms = lib.platforms.unix;
  };
}
