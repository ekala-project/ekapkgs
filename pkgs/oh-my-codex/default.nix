{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nodejs,
  codex,
  versionCheckHook,
}:

let
  versionData = {
    version = "0.21.6";
    hash = "sha256-Gf2wLW1W/h3HklgCRoTnsYoE/QpMYLYsdINxUyM8lxk=";
    cargoHash = "sha256-G8szrXsDrN2kK4UmsXaAxaytM5zm3E+BOOfGy1Z6jH0=";
    npmDepsHash = "sha256-m6Bk6q1Kku2jlvJRV6dklogDjCBz6Y9GZTdltVPOZDs=";
  };
  pname = "oh-my-codex";
  inherit (versionData)
    version
    hash
    cargoHash
    npmDepsHash
    ;

  src = fetchFromGitHub {
    owner = "Yeachan-Heo";
    repo = "oh-my-codex";
    tag = "v${version}";
    inherit hash;
  };

  nodePlatformMap = {
    x86_64-linux = "linux";
    aarch64-linux = "linux";
    aarch64-darwin = "darwin";
  };

  nodeArchMap = {
    x86_64-linux = "x64";
    aarch64-linux = "arm64";
    aarch64-darwin = "arm64";
  };

  system = stdenv.hostPlatform.system;
  nodePlatform = nodePlatformMap.${system} or (throw "Unsupported system for ${pname}: ${system}");
  nodeArch = nodeArchMap.${system} or (throw "Unsupported architecture for ${pname}: ${system}");

  mkNativeBinary =
    cargoPackage: binaryName:
    rustPlatform.buildRustPackage {
      pname = binaryName;
      inherit version src cargoHash;

      cargoBuildFlags = [
        "--package"
        cargoPackage
      ];

      cargoInstallFlags = [
        "--path"
        "."
        "--bin"
        binaryName
      ];

      doCheck = false;

      meta = {
        description = "Native sidecar for ${pname}";
        homepage = "https://github.com/Yeachan-Heo/oh-my-codex";
        changelog = "https://github.com/Yeachan-Heo/oh-my-codex/releases/tag/v${version}";
        license = lib.licenses.mit;
        sourceProvenance = [ lib.sourceTypes.fromSource ];
        mainProgram = binaryName;
        platforms = lib.platforms.unix;
      };
    };

  exploreHarness = mkNativeBinary "omx-explore-harness" "omx-explore-harness";
  sparkShell = mkNativeBinary "omx-sparkshell" "omx-sparkshell";
in
buildNpmPackage {
  npmDepsFetcherVersion = 2;
  inherit
    pname
    version
    src
    npmDepsHash
    ;

  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    npm ci --offline --ignore-scripts --cache=$npm_config_cache
    patchShebangs node_modules
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    root=$out/share/oh-my-codex
    mkdir -p $out/bin $root $root/src

    cp -r dist skills prompts templates package.json Cargo.toml Cargo.lock crates $root/
    cp -r src/scripts $root/src/

    npm prune --omit=dev
    cp -r node_modules $root/
    patchShebangs $root

    install -Dm755 ${exploreHarness}/bin/omx-explore-harness \
      $root/bin/omx-explore-harness

    cat > $root/bin/omx-explore-harness.meta.json <<META
    {
      "binaryName": "omx-explore-harness",
      "platform": "${nodePlatform}",
      "arch": "${nodeArch}",
      "strategy": "nix-packaged"
    }
    META

    install -Dm755 ${sparkShell}/bin/omx-sparkshell \
      $root/bin/native/${nodePlatform}-${nodeArch}/omx-sparkshell

    makeWrapper ${lib.getExe nodejs} $out/bin/omx \
      --add-flags "$root/dist/cli/omx.js" \
      --prefix PATH : ${lib.makeBinPath [ codex ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    native = {
      inherit exploreHarness sparkShell;
    };
  };

  meta = {
    description = "Multi-agent orchestration layer for OpenAI Codex CLI";
    homepage = "https://github.com/Yeachan-Heo/oh-my-codex";
    changelog = "https://github.com/Yeachan-Heo/oh-my-codex/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "omx";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
