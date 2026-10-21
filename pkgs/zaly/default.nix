{
  lib,
  fetchFromGitHub,
  bun,
}:

let
  version = "0.0.6";
in
bun.buildPackage {
  pname = "zaly";
  inherit version;

  src = fetchFromGitHub {
    owner = "folke";
    repo = "zaly";
    tag = "cli-v${version}";
    hash = "sha256-OAtIIfvkJM6k/IOfB+dHu928hBE5z8/VV77ZjP6hPjY=";
  };

  node_modulesHash = "sha256-Z9zDpKZ7yeac+b8qFKbG1n+Gi5nB6BImz/28ZnzSemQ=";
  node_modulesCopyMode = "overlay";
  node_modulesAttrs.installPhase = ''
    runHook preInstall
    mkdir -p $out
    find . -name node_modules -type d -prune -print | while read -r d; do
      mkdir -p "$out/$(dirname "$d")"
      cp -a "$d" "$out/$d"
    done
    cp package.json bun.lock $out/
    runHook postInstall
  '';

  # `z build` normally injects __VERSION__ at bundle time; running from source
  # falls back to "dev", so pin it to the packaged version.
  postPatch = ''
    substituteInPlace packages/cli/src/cli.ts \
      --replace-fail 'typeof __VERSION__ === "string" ? __VERSION__ : "dev"' \
        'typeof __VERSION__ === "string" ? __VERSION__ : "${version}"'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/zaly
    cp -r packages plugins docs $out/lib/zaly/
    cp package.json bun.lock $out/lib/zaly/
    cp -r node_modules $out/lib/zaly/
    makeWrapper ${lib.getExe bun} $out/bin/zaly \
      --add-flags "$out/lib/zaly/packages/cli/bin/zaly.ts"
    runHook postInstall
  '';

  doInstallCheck = false;

  meta = {
    description = "Hackable terminal coding agent";
    homepage = "https://github.com/folke/zaly";
    changelog = "https://github.com/folke/zaly/releases/tag/cli-v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "zaly";
    platforms = lib.platforms.all;
  };
}
