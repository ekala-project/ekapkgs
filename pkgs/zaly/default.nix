{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
}:

let
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "zaly";
    tag = "cli-v${version}";
    hash = "sha256-OAtIIfvkJM6k/IOfB+dHu928hBE5z8/VV77ZjP6hPjY=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "zaly-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      # bun creates a node_modules per workspace package, not just at the root.
      mkdir -p $out
      find . -name node_modules -type d -prune -print | while read -r d; do
        mkdir -p "$out/$(dirname "$d")"
        cp -a "$d" "$out/$d"
      done
      cp package.json bun.lock $out/
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-Z9zDpKZ7yeac+b8qFKbG1n+Gi5nB6BImz/28ZnzSemQ=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "zaly";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  dontConfigure = true;

  # `z build` normally injects __VERSION__ at bundle time; running from source
  # falls back to "dev", so pin it to the packaged version.
  postPatch = ''
    substituteInPlace packages/cli/src/cli.ts \
      --replace-fail 'typeof __VERSION__ === "string" ? __VERSION__ : "dev"' \
        'typeof __VERSION__ === "string" ? __VERSION__ : "${version}"'
  '';

  # Upstream builds with a private `z build` tool; bun resolves the workspace
  # `bun` export condition straight to TS sources, so run from source instead.
  installPhase = ''
    runHook preInstall
    cp -r ${node_modules}/. .
    mkdir -p $out/lib/zaly
    cp -r packages plugins docs $out/lib/zaly/
    cp package.json bun.lock $out/lib/zaly/
    cp -r node_modules $out/lib/zaly/
    makeWrapper ${lib.getExe bun} $out/bin/zaly \
      --add-flags "$out/lib/zaly/packages/cli/bin/zaly.ts"
    runHook postInstall
  '';

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
