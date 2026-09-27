{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  installShellFiles,
  nodejs,
  perl,
  python3,
  xcbuild,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs.v22; };
in
buildNpmPackage' {
  pname = "bitwarden-cli";
  version = "2026.7.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    tag = "cli-v2026.7.0";
    hash = "sha256-8PYjRa1lhs53FCfqPBqH9712X1ek02wbkI+kW5tkepE=";
  };

  postPatch = ''
    # remove code under unfree license
    rm -r bitwarden_license
  '';

  npmDepsHash = "sha256-1G9rW+e8ux6H8XugmoVjI1EucPfMg8syeNP5SQldC3M=";

  nativeBuildInputs = [
    installShellFiles
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    perl
    xcbuild.xcrun
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];

  buildPhase = ''
    runHook preBuild

    # Install dependencies with ignore-scripts to skip prebuild scripts
    npm ci --offline --cache=$npm_config_cache --legacy-peer-deps --ignore-scripts

    # Patch shebangs in node_modules after install
    patchShebangs node_modules

    # Remove prebuilt binaries - we want to build everything from source
    shopt -s globstar nullglob
    rm -rf node_modules/**/prebuilds
    shopt -u globstar nullglob

    # Point node-gyp at local node headers to avoid network fetches
    local nodedir="$(dirname $(dirname $(command -v node)))"
    export npm_config_nodedir="$nodedir"

    # Pre-populate node-gyp cache so it doesn't try to download headers
    local nodeVersion="$(node --version | sed 's/^v//')"
    local gypDir="$HOME/.cache/node-gyp/$nodeVersion"
    mkdir -p "$gypDir/include/node"
    cp -r "$nodedir/include/node/"* "$gypDir/include/node/"
    cp "$nodedir/include/node/common.gypi" "$gypDir/common.gypi"
    echo 11 > "$gypDir/installVersion"

    npm rebuild --verbose

    # Run the build (script is in the apps/cli workspace)
    npm run build:oss:prod --workspace apps/cli --cache=$npm_config_cache

    # Remove build artifacts that bloat the closure
    shopt -s globstar nullglob
    rm -rf node_modules/**/{*.target.mk,binding.Makefile,config.gypi,Makefile,Release/.deps}
    shopt -u globstar nullglob

    runHook postBuild
  '';

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    # Install the CLI package
    local dest="$out/lib/node_modules/@bitwarden/cli"
    mkdir -p "$dest" "$out/bin"

    # Copy the webpack build output (self-contained bundle)
    cp -r apps/cli/build/* "$dest/"

    # Copy node_modules needed at runtime, removing workspace symlinks
    cp -r node_modules "$dest/node_modules"
    # Remove @bitwarden workspace symlinks (bundled via webpack, not needed at runtime)
    rm -rf "$dest/node_modules/@bitwarden" "$dest/node_modules/.bin"
    # Remove any remaining dangling symlinks
    find "$dest/node_modules" -xtype l -delete 2>/dev/null || true

    # Create the bw wrapper script
    makeWrapper "${nodejs.v22}/bin/node" "$out/bin/bw" \
      --add-flags "$dest/bw.js"

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bw --zsh <($out/bin/bw completion --shell zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    changelog = "https://github.com/bitwarden/clients/releases/tag/cli-v2026.7.0";
    description = "Secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
  };
}
