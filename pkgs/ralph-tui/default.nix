{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  versionCheckHook,
}:

let
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "subsy";
    repo = "ralph-tui";
    tag = "v${version}";
    hash = "sha256-FqGniyxbOMMbDN/S0gYcdHiOr+nNQuuBgQ8M7M1UP6k=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "ralph-tui-node_modules";
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
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp package.json $out/
      [ -f bun.lock ] && cp bun.lock $out/ || true
      runHook postInstall
    '';

    # fixup rewrites native libs and makes the FOD non-reproducible
    dontFixup = true;
    outputHash = "sha256-iClXVYxu2bKqRtp1VNTTYSsMM77LP+leRPgzX6q0xo4=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "ralph-tui";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    bun run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/ralph-tui $out/bin
    cp -r dist node_modules package.json $out/lib/ralph-tui/
    makeWrapper ${lib.getExe bun} $out/bin/ralph-tui \
      --add-flags "run $out/lib/ralph-tui/dist/cli.js"
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "AI Agent Loop Orchestrator TUI";
    homepage = "https://github.com/subsy/ralph-tui";
    changelog = "https://github.com/subsy/ralph-tui/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ralph-tui";
    platforms = lib.platforms.unix;
  };
}
