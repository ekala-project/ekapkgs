{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchPnpmDeps,
  pnpm,
  pnpmConfigHook,
  nodejs,
  makeWrapper,
  python3,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "MiniMax-AI";
    repo = "minimax-code";
    tag = "v${version}";
    hash = "sha256-mecJpG2Qk8BN371b+9XZHdERlzycIqAwuDBqNEUwdJk=";
  };

  # scripts/build.mjs extracts mcode-tools from this registry tarball. Prefetch
  # it so the build stays offline (build.mjs reads it from .cache/artifacts/).
  mcodeToolsArchive = fetchurl {
    url = "https://registry.npmjs.org/@minimax-ai/code/-/code-0.3.11.tgz";
    hash = "sha512-sBOd8yvQRVuQNoGvzCDwXKaj5rQxLI3gKnojWS4+0wnMU9IXtxObSqbfBxz30Lze/zitRtSG2v76iJGHOmHRUA==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "minimax-code";
  inherit version src;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm.v9;
    fetcherVersion = 3;
    hash = "sha256-NAMfAH9Y8w537oetrwvSrpsk8U8Z2RobD+F5CZVl71g=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.v9
    pnpmConfigHook
    makeWrapper
    python3
  ];

  preBuild = ''
    mkdir -p .cache/artifacts
    cp ${mcodeToolsArchive} .cache/artifacts/code-0.3.11.tgz
    chmod u+w .cache/artifacts/code-0.3.11.tgz
  '';

  buildPhase = ''
    runHook preBuild
    node scripts/build.mjs
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/minimax-code $out/bin
    cp -r dist/. $out/lib/node_modules/minimax-code/

    # better-sqlite3 ships prebuilt-incompatible binaries; keep only the addon.
    find $out -path '*/better-sqlite3/build/*' ! -name better_sqlite3.node -type f -delete

    chmod +x $out/lib/node_modules/minimax-code/cli.js \
      $out/lib/node_modules/minimax-code/mcode-tools.js

    makeWrapper ${lib.getExe nodejs} $out/bin/mcode \
      --add-flags "$out/lib/node_modules/minimax-code/cli.js"
    makeWrapper ${lib.getExe nodejs} $out/bin/mcode-tools \
      --add-flags "$out/lib/node_modules/minimax-code/mcode-tools.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/mcode --version | grep -q '${version}'
    runHook postInstallCheck
  '';

  meta = {
    description = "Open-source coding agent for your terminal, powered by MiniMax";
    homepage = "https://github.com/MiniMax-AI/minimax-code";
    changelog = "https://github.com/MiniMax-AI/minimax-code/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "mcode";
    platforms = lib.platforms.all;
  };
})
