{
  lib,
  fetchFromGitHub,
  bun,
}:

bun.buildPackage {
  pname = "ccstatusline";
  version = "2.2.30";

  src = fetchFromGitHub {
    owner = "sirmalloc";
    repo = "ccstatusline";
    tag = "v2.2.30";
    hash = "sha256-5WteIWSlrPJjIcrkfUwV1Xpl+lhutW9ZwMeejq6TD0s=";
  };

  node_modulesHash = "sha256-WwYBXa0qP8f4QbAQB9rGvUi6tJTeKsQHXrNI7PytZa8=";

  bunBuildCommand = ''
    patchShebangs node_modules 2>/dev/null || true
    bun build src/ccstatusline.ts --target=node --splitting --format=esm --outdir=dist --target-version=14
    bun run scripts/replace-version.ts || true
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ccstatusline
    cp -r dist package.json $out/lib/ccstatusline/
    makeWrapper ${lib.getExe bun} $out/bin/ccstatusline \
      --add-flags "$out/lib/ccstatusline/dist/ccstatusline.js"
    runHook postInstall
  '';

  doInstallCheck = false;

  meta = {
    description = "Customizable status line formatter for the Claude Code CLI";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    changelog = "https://github.com/sirmalloc/ccstatusline/releases/tag/v2.2.30";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "ccstatusline";
    platforms = lib.platforms.unix;
  };
}
