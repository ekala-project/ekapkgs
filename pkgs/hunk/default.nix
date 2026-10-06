{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "modem-dev";
    repo = "hunk";
    tag = "v${version}";
    hash = "sha256-JQRNs0JG3v7lN1rFNikMyevAQjV0vfCCXjfPxmcKmqQ=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "hunk-node_modules";
    inherit version src;

    nativeBuildInputs = [ bun ];

    dontConfigure = true;

    # Pin every dependency to the exact version vendored in the lockfile.
    postPatch = ''
      for f in package.json packages/*/package.json; do
        if [ -f "$f" ]; then
          sed -i 's/: "\^/: "/g; s/: "~/: "/g' "$f"
        fi
      done
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
    outputHash = "sha256-Eu71EvMbRac5fraJELQMnD8y++m4wKIzbG9LsSuRsAg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "hunk";
  inherit version src;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    cp -r ${node_modules}/node_modules .
    bun build --compile --no-compile-autoload-bunfig \
      ./packages/hunk/src/main.tsx \
      ./packages/hunk/src/highlightWorkerEntry.ts \
      --outfile hunk-bin
    runHook postBuild
  '';

  # bun build --compile embeds the JS bundle inside the executable; stripping
  # corrupts it.
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 ./hunk-bin $out/share/hunk/bin/hunk
    cp -r ./packages/hunk/skills $out/share/hunk/
    makeWrapper $out/share/hunk/bin/hunk $out/bin/hunk
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Terminal diff viewer for agentic changesets";
    homepage = "https://github.com/modem-dev/hunk";
    changelog = "https://github.com/modem-dev/hunk/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hunk";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
