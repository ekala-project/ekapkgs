{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  python3,
  makeWrapper,
  electron_43,
  vulkan-helper,
  gogdl,
  legendary-gl,
  nile,
  comet-gog_heroic,
  umu-launcher,
}:

let
  pnpm = pnpm_10;
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "heroic-unwrapped";
  version = "2.22.3";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "HeroicGamesLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gXG0ojLIT28aAYXhpMmR9Oksmdfidr4m6M7PDJWwa1c=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    python3
    makeWrapper
  ];

  patches = [
    ./fix-non-steam-shortcuts.patch
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}

    pnpm --offline electron-vite build
    pnpm --offline electron-builder \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/heroic"
    cp -r dist/*-unpacked/resources "$out/share/heroic"

    bin_dir="$out/share/heroic/resources/app.asar.unpacked/build/bin"

    rm -r "$bin_dir"
    mkdir -p "$bin_dir/x64/linux/"

    ln -s \
      "${lib.getExe gogdl}" \
      "${lib.getExe legendary-gl}" \
      "${lib.getExe nile}" \
      "${lib.getExe comet-gog_heroic}" \
      "${lib.getExe vulkan-helper}" \
      "$bin_dir/x64/linux/"

    makeWrapper "${lib.getExe electron}" "$out/bin/heroic" \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --suffix PATH ":" "${
        lib.makeBinPath (
          lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
            umu-launcher
          ]
        )
      }" \
      --add-flags --disable-gpu-compositing \
      --add-flags $out/share/heroic/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -D "flatpak/com.heroicgameslauncher.hgl.desktop" "$out/share/applications/com.heroicgameslauncher.hgl.desktop"
    install -D "src/frontend/assets/heroic-icon.svg" "$out/share/icons/hicolor/scalable/apps/com.heroicgameslauncher.hgl.svg"
    substituteInPlace "$out/share/applications/com.heroicgameslauncher.hgl.desktop" \
      --replace-fail "Exec=heroic-run" "Exec=heroic"

    runHook postInstall
  '';

  meta = {
    description = "Native GOG, Epic, and Amazon Games Launcher for Linux";
    homepage = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher";
    changelog = "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "heroic";
  };
})
