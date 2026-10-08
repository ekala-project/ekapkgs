{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm,
  pnpmConfigHook,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  ripgrep,
  difftastic,
}:

let
  pin = {
    version = "1.2.5";
    srcRev = "4beb3543cfdeb507be838016996f7a0f65cf7b49";
    srcHash = "sha256-caGGajnyOw9a4YB55j1Ho7s9ymuMJWYSC0pRG6I1o2k=";
    pnpmDepsHash = "sha256-zPZQFAEI1wcceOt/hPxDeVnpD26hLWJGDoVHfg4DABY=";
  };

  pnpmWorkspaces = [
    "happy"
    "@slopus/happy-wire"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  inherit (pin) version;

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy";
    rev = pin.srcRev;
    hash = pin.srcHash;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm.v10;
    hash = pin.pnpmDepsHash;
    fetcherVersion = 3;
  };

  inherit pnpmWorkspaces;

  nativeBuildInputs = [
    nodejs
    pnpm.v10
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    chmod -R u+w node_modules packages 2>/dev/null || true
    patchShebangs node_modules packages 2>/dev/null || true
    for d in $PWD/node_modules/.bin $PWD/packages/*/node_modules/.bin; do export PATH="$d:$PATH"; done
    pnpm --filter @slopus/happy-wire build
    pnpm --filter happy build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm config set inject-workspace-packages true
    pnpm --filter happy --prod --ignore-scripts deploy $out/lib/happy

    rm -rf $out/lib/happy/tools/archives $out/lib/happy/tools/unpacked
    mkdir -p $out/lib/happy/tools/unpacked
    ln -s ${lib.getExe ripgrep} $out/lib/happy/tools/unpacked/rg
    ln -s ${lib.getExe difftastic} $out/lib/happy/tools/unpacked/difft

    mkdir -p $out/bin
    for bin in happy happy-mcp; do
      makeWrapper ${nodejs}/bin/node $out/bin/$bin \
        --add-flags --no-warnings \
        --add-flags --no-deprecation \
        --add-flags $out/lib/happy/bin/$bin.mjs \
        --prefix PATH : ${
          lib.makeBinPath [
            nodejs
            ripgrep
            difftastic
          ]
        }
    done

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Mobile and Web client for Codex and Claude Code, with realtime voice and encryption";
    homepage = "https://github.com/slopus/happy";
    changelog = "https://github.com/slopus/happy/commits/main/packages/happy-cli";
    downloadPage = "https://www.npmjs.com/package/happy";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "happy";
    platforms = lib.platforms.all;
  };
})
