{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  jq,
}:

let
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "MrLesk";
    repo = "Backlog.md";
    tag = "v${version}";
    hash = "sha256-NFI59EXjmux1ZgP5KSv7zKhhnaJtMBERQYxHXatm31U=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "backlog-md-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      jq
    ];

    dontConfigure = true;

    # bun's offline resolver refuses semver ranges when only one version is
    # present in the store, so collapse ^/~ to exact pins in package.json and
    # bun.lock.
    postPatch = ''
      ${lib.getExe jq} '
        if .dependencies    then .dependencies    |= with_entries(.value |= ltrimstr("^") | .value |= ltrimstr("~")) else . end |
        if .devDependencies then .devDependencies |= with_entries(.value |= ltrimstr("^") | .value |= ltrimstr("~")) else . end
      ' package.json > package.json.tmp && mv package.json.tmp package.json
      sed -i 's/: "\^/: "/g; s/: "~/: "/g' bun.lock
    '';

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
      cp package.json $out/package.json
      [ -f bun.lock ] && cp bun.lock $out/ || true
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-FWD+2HrGziyfDpfGPABaj89Pf6YQ41oc8owLXFDmbBs=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "backlog-md";
  inherit version src;

  nativeBuildInputs = [ bun ];

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    bun scripts/build.ts
    runHook postBuild
  '';

  # bun compile embeds JS in the binary; stripping would break it.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dist/backlog $out/bin/backlog
    runHook postInstall
  '';

  # Upstream's package.json lags the tag (binary reports 1.52.0), so no strict
  # version check.
  doInstallCheck = false;

  meta = {
    description = "Manage project collaboration between humans and AI agents in a git ecosystem";
    homepage = "https://github.com/MrLesk/Backlog.md";
    changelog = "https://github.com/MrLesk/Backlog.md/releases";
    license = lib.licenses.mit;
    mainProgram = "backlog";
    platforms = lib.platforms.unix;
  };
}
