{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  cmake,
  gitMinimal,
  jq,
  makeWrapper,
  nodejs,
  pnpm,
  pnpmConfigHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pnpm10 = pnpm.v10;

  # pnpm 10.33+ rejects patchedDependencies mismatch between lockfile and
  # pnpm-workspace.yaml; strip from both for frozen install.
  stripPatchedDeps = ''
    sed -i '/^patchedDependencies:/,/^[^ ]/{/^patchedDependencies:/d;/^  /d;}' pnpm-lock.yaml pnpm-workspace.yaml
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openclaw";
  version = "2026.9.5";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M0nfeZDy6MafWCfqefwDRdL1MFLs8l1YZJmB6sV9IyU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm10;
    hash = "sha256-c/ot2z4LLA6hNq9FJsg+7XXTElpWsb/iHNTCkYxpP68=";
    fetcherVersion = 3;
    prePnpmInstall = stripPatchedDeps;
  };

  nativeBuildInputs = [
    cmake
    gitMinimal
    makeWrapper
    nodejs
    pnpm10
    pnpmConfigHook
  ];

  dontUseCmakeConfigure = true;

  env = {
    NODE_OPTIONS = "--max-old-space-size=4608";
    OPENCLAW_TSDOWN_MAX_OLD_SPACE_MB = "4608";
    FS_SAFE_NATIVE_MODE = "off";
    RAYON_NUM_THREADS = "4";
  };

  postPatch = stripPatchedDeps;

  buildPhase = ''
    runHook preBuild
    chmod -R u+w node_modules 2>/dev/null || true
    patchShebangs node_modules 2>/dev/null || true
    for d in $PWD/node_modules/.bin $PWD/packages/*/node_modules/.bin $PWD/apps/*/node_modules/.bin; do export PATH="$d:$PATH"; done
    export OPENCLAW_BUILD_TIMESTAMP="$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y-%m-%dT%H:%M:%S.000Z)"
    pnpm build
    pnpm ui:build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/openclaw}
    cp -r * $out/lib/openclaw/

    pushd $out/lib/openclaw
    rm -rf test apps Swabble Peekaboo tsconfig.json \
      vitest.config.ts vitest.e2e.config.ts vitest.live.config.ts \
      Dockerfile Dockerfile.sandbox Dockerfile.sandbox-browser \
      docker-compose.yml docker-setup.sh README-header.png \
      CHANGELOG.md CONTRIBUTING.md SECURITY.md appcast.xml \
      pnpm-lock.yaml pnpm-workspace.yaml \
      assets/dmg-background.png assets/dmg-background-small.png
    find . -name "__screenshots__" -type d -exec rm -rf {} + 2>/dev/null || true
    find . -name "*.test.ts" -delete
    popd

    makeWrapper ${nodejs}/bin/node $out/bin/openclaw \
      --add-flags "$out/lib/openclaw/dist/entry.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    jq
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  postInstallCheck = ''
    buildId=$(jq -re .buildId $out/lib/openclaw/dist/build-info.json)
    grep -rqF "$buildId" $out/lib/openclaw/dist/control-ui/assets
  '';
  preVersionCheck = ''
    version=${lib.head (lib.splitString "-" finalAttrs.version)}
  '';

  meta = {
    description = "Your own personal AI assistant. Any OS. Any Platform. The lobster way";
    homepage = "https://openclaw.ai";
    changelog = "https://github.com/openclaw/openclaw/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = lib.platforms.all;
    mainProgram = "openclaw";
  };
})
