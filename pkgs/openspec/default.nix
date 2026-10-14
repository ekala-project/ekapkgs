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
  pname = "openspec";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "Fission-AI";
    repo = "OpenSpec";
    rev = "9111a7654d7800391459431fff4eaf66e33a3d2e";
    hash = "sha256-FUGxAvuptFlZ8rsBVv9jlSxhXb3MCtcPB1KpXtMu1bQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm.v10;
    fetcherVersion = 3;
    hash = "sha256-NIMHf7t+FnBgsswDtB1k4E/zX1ks1r3708ggE2ps9E8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.v10
    pnpmConfigHook
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    chmod -R u+w node_modules 2>/dev/null || true
    patchShebangs node_modules 2>/dev/null || true
    for d in $PWD/node_modules/.bin; do export PATH="$d:$PATH"; done
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/openspec
    cp -r dist bin schemas package.json $out/lib/openspec/
    pnpm prune --prod || true
    cp -r node_modules $out/lib/openspec/
    makeWrapper ${nodejs}/bin/node $out/bin/openspec \
      --add-flags "$out/lib/openspec/bin/openspec.js"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Spec-driven development for AI coding assistants";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    changelog = "https://github.com/Fission-AI/OpenSpec/releases";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "openspec";
    platforms = lib.platforms.all;
  };
})
