{
  stdenv,
  lib,
  nodejs,
  pnpm,
  node-gyp,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  electron_44,
  python3,
  makeWrapper,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  jq,
  makeDesktopItem,
  copyDesktopItems,
  replaceVars,
  noto-fonts-color-emoji,

  # Missing in ekapkgs -- needed by sub-packages
  npmHooks ? throw "signal-desktop: npmHooks is not yet available in ekapkgs (needed by libsignal-node)",
  dump_syms ? throw "signal-desktop: dump_syms is not yet available in ekapkgs (needed by signal-sqlcipher)",
  gclient2nix ? throw "signal-desktop: gclient2nix is not yet available in ekapkgs (needed by webrtc)",

  # command line arguments which are always set e.g "--password-store=kwallet6"
  commandLineArgs ? "",

  withAppleEmojis ? false,
}:
assert lib.warnIf (commandLineArgs != "")
  "`commandLineArgs` has been deprecated and will be removed in the future. Consider creating a wrapper script or a desktop entry with your desired flags."
  true;
let
  electron = electron_44;

  libsignal-node = callPackage ./libsignal-node.nix { inherit nodejs npmHooks; };
  signal-sqlcipher = callPackage ./signal-sqlcipher.nix {
    inherit nodejs dump_syms;
  };

  webrtc = callPackage ./webrtc.nix { inherit gclient2nix; };
  ringrtc = callPackage ./ringrtc.nix { inherit webrtc; };

  version = "8.29.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "Signal-Desktop";
    tag = "v${version}";
    hash = "sha256-QwI3OzZc1octWZZ7G4SNlG1Ohi7w2BManPFFN5gTorQ=";
    postFetch = ''
      rm $out/fonts/emoji.woff2
    '';
  };

  apple-emoji = fetchurl {
    url = "https://github.com/signalapp/Signal-Desktop/raw/refs/tags/v${version}/fonts/emoji.woff2";
    hash = "sha256-yGdx5GZVnsmYn+SI9/yAfGhRyzO5Q5Bd0bW9AQyVzv8=";
    meta.license = lib.licenses.unfree;
  };

  sticker-creator = stdenv.mkDerivation (finalAttrs: {
    pname = "signal-desktop-sticker-creator";
    inherit src version;

    pnpmRoot = "sticker-creator";
    pnpmWorkspaces = [ "signal-art-creator" ];

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        src
        version
        pnpmWorkspaces
        ;
      inherit pnpm;
      prePnpmInstall = ''
        pnpm config set fetch-timeout 300000
      '';
      # TODO: nixpkgs uses fetcherVersion 4; corepkgs only supports up to 3.
      # Hash must be recomputed with: nix-build -A signal-desktop.passthru.sticker-creator.pnpmDeps
      fetcherVersion = 3;
      hash = lib.fakeHash;
    };

    strictDeps = true;
    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpmBuildHook
      pnpm
    ];

    installPhase = ''
      runHook preInstall
      cp -r sticker-creator/dist $out
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-desktop";
  inherit src version;

  strictDeps = true;
  nativeBuildInputs = [
    node-gyp
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm
    makeWrapper
    python3
    jq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  patches = [
    ./force-90-days-expiration.patch
  ]
  ++ lib.optional (!withAppleEmojis) (
    replaceVars ./replace-apple-emoji-with-noto-emoji.patch {
      inherit noto-fonts-color-emoji;
    }
  );

  postPatch = ''
    substituteInPlace app/updateDefaultSession.main.ts \
      --replace-fail "\''${process.versions.electron}" "`jq -r '.devDependencies.electron' < package.json`"

    substituteInPlace config/production.json \
      --replace-fail '"updatesEnabled": true' '"updatesEnabled": false'

    substituteInPlace pnpm-workspace.yaml \
      --replace-fail "verifyDepsBeforeRun: prompt" "verifyDepsBeforeRun: false"

    substituteInPlace package.json \
      --replace-fail '"artifactBuildCompleted": "scripts/artifact-build-completed.mjs",' "" \
      --replace-fail '"afterSign": "scripts/after-sign.mjs",' "" \
      --replace-fail '"afterPack": "scripts/after-pack.mjs",' "" \
      --replace-fail '"sign": "scripts/sign-macos.mjs",' "" \
      --replace-fail '"afterAllArtifactBuild": "scripts/after-all-artifact-build.mjs",' ""
  ''
  + lib.optionalString withAppleEmojis ''
    cp ${apple-emoji} fonts/emoji.woff2
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    inherit pnpm;
    prePnpmInstall = ''
      pnpm config set fetch-timeout 300000
    '';
    # TODO: nixpkgs uses fetcherVersion 4; corepkgs only supports up to 3.
    # Hash must be recomputed with: nix-build -A signal-desktop.pnpmDeps
    fetcherVersion = 3;
    hash = lib.fakeHash;
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    SIGNAL_ENV = "production";
    SOURCE_DATE_EPOCH = 1790889255;
  };

  preBuild = ''
    if [ "`jq -r '.engines.node' < package.json | cut -d. -f1`" != "${lib.versions.major nodejs.version}" ]
    then
      die "nodejs version mismatch"
    fi

    if [ "`jq -r '.devDependencies.electron' < package.json | cut -d. -f1`" != "${lib.versions.major electron.version}" ]
    then
      die "electron version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/libsignal-client"' < package.json`" != "${libsignal-node.version}" ]
    then
      die "libsignal-client version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/sqlcipher"' < package.json`" != "${signal-sqlcipher.version}" ]
    then
      die "signal-sqlcipher version mismatch"
    fi

    if [ "`jq -r '.dependencies."@signalapp/ringrtc"' < package.json`" != "${ringrtc.version}" ]
    then
      die "ringrtc version mismatch"
    fi

    install -D ${ringrtc}/lib/libringrtc${stdenv.hostPlatform.extensions.library} \
      node_modules/@signalapp/ringrtc/build/libringrtc.node

    substituteInPlace package.json \
      --replace-fail '"node_modules/@signalapp/ringrtc/build/''${platform}/*''${arch}*.node",' \
                     '"node_modules/@signalapp/ringrtc/build/libringrtc.node",'

    substituteInPlace node_modules/@signalapp/ringrtc/dist/ringrtc/Native.js \
      --replace-fail 'exports.default = require(`../../build/''${os.platform()}/libringrtc-''${process.arch}.node`);' \
                     'exports.default = require(`../../build/libringrtc.node`);'

    rm -r node_modules/@signalapp/libsignal-client/prebuilds
    cp -r ${libsignal-node}/lib node_modules/@signalapp/libsignal-client/prebuilds

    rm -r node_modules/@signalapp/sqlcipher
    cp -r ${signal-sqlcipher} node_modules/@signalapp/sqlcipher

    export npm_config_nodedir=${electron.headers}
    pushd node_modules/fs-xattr
    node-gyp rebuild
    popd
    test -f node_modules/fs-xattr/build/Release/xattr.node

    pushd packages/windows-ucv
    pnpm run build
    popd
    test -f node_modules/@signalapp/windows-ucv/dist/index.js

    pushd packages/types
    pnpm run build
    popd
    test -f node_modules/@signalapp/types/dist/index.std.cjs

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    cp -r ${sticker-creator} sticker-creator/dist
  '';

  pnpmBuildScript = "generate";

  postBuild = ''
    pnpm exec electron-builder \
      ${
        if stdenv.hostPlatform.isDarwin then "--mac" else "--linux"
      } "dir:${stdenv.hostPlatform.node.arch}" \
      --config.extraMetadata.environment=$SIGNAL_ENV \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r dist/mac*/Signal.app $out/Applications
    makeWrapper "$out/Applications/Signal.app/Contents/MacOS/Signal" "$out/bin/signal-desktop" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/share/polkit-1/actions
    cp -r dist/*-unpacked/resources $out/share/signal-desktop
    mv $out/share/signal-desktop/*.policy $out/share/polkit-1/actions/

    for icon in build/icons/png/*
    do
      install -Dm644 $icon $out/share/icons/hicolor/`basename ''${icon%.png}`/apps/signal-desktop.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/signal-desktop" \
      --add-flags "$out/share/signal-desktop/app.asar" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "signal";
      desktopName = "Signal";
      exec = "${finalAttrs.meta.mainProgram} %U";
      type = "Application";
      terminal = false;
      icon = "signal-desktop";
      comment = "Private messaging from your desktop";
      startupWMClass = "signal";
      mimeTypes = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];

  passthru = {
    inherit
      apple-emoji
      libsignal-node
      ringrtc
      webrtc
      sticker-creator
      signal-sqlcipher
      ;
  };

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage = "https://signal.org/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only

      # Various npm packages
      free
    ];
    mainProgram = "signal-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
