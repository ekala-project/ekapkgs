{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs,
  python3,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.27.22";

  src = fetchFromGitHub {
    owner = "backnotprop";
    repo = "plannotator";
    tag = "v${version}";
    hash = "sha256-Y9baSp1Z3n8dVUG/gvj63n6gq/Ufw16v9zXLdWLAX3k=";
  };

  platformMap = {
    x86_64-linux = "bun-linux-x64";
    aarch64-linux = "bun-linux-arm64";
    aarch64-darwin = "bun-darwin-arm64";
  };
  bunTarget =
    platformMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  node_modules = stdenv.mkDerivation {
    pname = "plannotator-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      python3
    ];

    dontConfigure = true;

    patches = lib.optional ((builtins.readFile ./fix-stale-bun-lock.patch) != "") [
      ./fix-stale-bun-lock.patch
    ];

    postPatch = ''
      # Bun still tries registry manifest lookups for a few workspace deps even
      # with a populated cache; rewrite the workspace manifests to the
      # lockfile's exact versions first.
      ${lib.getExe python3} ${./fix-bun-offline-install.py}
    '';

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --linker=isolated --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/repo
      runHook postInstall
    '';

    dontFixup = true;
    outputHash = "sha256-pjOworJcGdghAknH9F2gjU/7lFuR/OIFrkfnRx7M+WY=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  pname = "plannotator";
  inherit version src;

  nativeBuildInputs = [ bun ];

  patches = lib.optional ((builtins.readFile ./fix-stale-bun-lock.patch) != "") [
    ./fix-stale-bun-lock.patch
  ];

  postPatch = ''
    ${lib.getExe python3} ${./fix-bun-offline-install.py}
  '';

  dontStrip = true;

  buildPhase = ''
    runHook preBuild

    cp -rf ${node_modules}/repo/. .
    chmod -R u+w .
    patchShebangs . || true
    # patchShebangs skips some .bun-nested CLI shims; fix any remaining
    # `/usr/bin/env node` shebangs (absent on NixOS) directly.
    grep -rIl '^#!/usr/bin/env node' node_modules apps 2>/dev/null | while IFS= read -r f; do
      sed -i '1s|^#!/usr/bin/env node|#!${lib.getExe nodejs}|' "$f"
    done
    export PATH=$PWD/apps/review/node_modules/.bin:$PWD/node_modules/.bin:$PATH

    mkdir -p .bun-tmp .bun-install
    export BUN_TMPDIR=$PWD/.bun-tmp
    export BUN_INSTALL=$PWD/.bun-install

    bun run build:review
    bun run build:hook
    bun build apps/hook/server/index.ts \
      --compile \
      --no-compile-autoload-bunfig \
      --target=${bunTarget} \
      --define '__CLI_VERSION__="${version}"' \
      --outfile plannotator

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 plannotator $out/bin/plannotator
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Interactive plan and code review tool for AI coding agents";
    homepage = "https://github.com/backnotprop/plannotator";
    changelog = "https://github.com/backnotprop/plannotator/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "plannotator";
  };
}
