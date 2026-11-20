{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  fd,
  makeWrapper,
  node-gyp,
  nodejs,
  python3,
  pnpm,
  pnpmConfigHook,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kimi-code";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-code";
    tag = "@moonshot-ai/kimi-code@${finalAttrs.version}";
    hash = "sha256-4JnDvZ+4z6tVCjor0fIQfSDHXvLaVIviifQMUy6fmZ8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm.v10;
    fetcherVersion = 3;
    hash = "sha256-xrn34bQ76s+ouOZPHZ4TBkpTHxG7gZejmx8RqSii2uA=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.v10
    pnpmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    node-gyp
    python3
  ];

  buildPhase = ''
    runHook preBuild
    chmod -R u+w node_modules packages 2>/dev/null || true
    patchShebangs node_modules packages 2>/dev/null || true
    for d in $PWD/node_modules/.bin $PWD/packages/*/node_modules/.bin; do export PATH="$d:$PATH"; done
    pnpm --filter @moonshot-ai/kimi-code build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm config set inject-workspace-packages true
    pnpm --filter @moonshot-ai/kimi-code --prod --ignore-scripts deploy $out/lib/kimi-code

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      pushd $out/lib/kimi-code/node_modules/.pnpm/node-pty@*/node_modules/node-pty
      node ${nodejs}/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js rebuild --nodedir=${nodejs}
      find build -mindepth 1 -maxdepth 1 ! -name Release -exec rm -rf {} +
      find build/Release -mindepth 1 ! -name '*.node' -exec rm -rf {} +
      popd
    ''}

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/kimi \
      --add-flags $out/lib/kimi-code/dist/main.mjs \
      --set KIMI_CODE_NO_AUTO_UPDATE 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          ripgrep
        ]
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "The Starting Point for Next-Gen Agents";
    homepage = "https://github.com/MoonshotAI/kimi-code";
    changelog = "https://github.com/MoonshotAI/kimi-code/releases/tag/%40moonshot-ai%2Fkimi-code%40${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "kimi";
    platforms = lib.platforms.unix;
  };
})
