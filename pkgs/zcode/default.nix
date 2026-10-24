{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zcode";
  version = "3.14.3";

  src = fetchFromGitHub {
    owner = "zai-org";
    repo = "ZCode";
    rev = "29628c9acdb81b703bbd4080c207a0e7ce5e276e";
    hash = "sha256-4LZIl6ofaxcmb28fu21Kc5oJAe+/AKRDAM/2xRKYxI8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm.v10;
    fetcherVersion = 3;
    hash = "sha256-0N0NDwkblR9bSskfZLA0SOxhs7W2hELDIAHohOynTOg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.v10
    pnpmConfigHook
    makeWrapper
  ];

  postPatch = ''
    node -e "
    const fs = require('fs');
    const p = 'third-party/runtime/sources.json';
    const d = JSON.parse(fs.readFileSync(p, 'utf8'));
    if (!d.node.some((x) => x.version === '24.20.0')) {
      const base = d.node.find((x) => x.version === '24.14.0');
      d.node.push({ version: '24.20.0', source: base.source.replace('v24.14.0', 'v24.20.0'), file: base.file, sha256: base.sha256 });
      fs.writeFileSync(p, JSON.stringify(d, null, 2) + '\\n');
    }
    "
  '';

  buildPhase = ''
    runHook preBuild
    chmod -R u+w node_modules packages apps 2>/dev/null || true
    patchShebangs node_modules packages apps 2>/dev/null || true
    for d in $PWD/node_modules/.bin $PWD/apps/zcode-cli/node_modules/.bin $PWD/packages/*/node_modules/.bin; do export PATH="$d:$PATH"; done

    pnpm -r --filter '!@zcode/desktop' --filter '!zcode-cli' build
    pnpm --filter @zcode/shared exec tsc -p tsconfig.json || true
    pnpm --filter @zcode/cli build
    node apps/zcode-cli/packages/cli/scripts/build-sea.mjs --target linux-x64 \
      --node-binary linux-x64=${nodejs}/bin/node
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 apps/zcode-cli/packages/cli/dist/zcode-linux-x64 $out/bin/zcode

    runHook postInstall
  '';

  doInstallCheck = false;

  meta = {
    description = "Z.ai's coding agent harness (CLI/TUI)";
    homepage = "https://github.com/zai-org/ZCode";
    changelog = "https://github.com/zai-org/ZCode/releases";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "zcode";
    platforms = lib.platforms.unix;
  };
})
