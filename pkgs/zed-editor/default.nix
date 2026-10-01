{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  protobuf,
  fontconfig,
  libgit2,
  openssl,
  sqlite,
  zlib,
  zstd,
  glib,
  alsa-lib,
  libxkbcommon,
  wayland,
  libxcb,
  stdenv,
  vulkan-loader,
  cargo-about,
  makeBinaryWrapper,
  nodejs,
  libGL,
  libx11,
  libxext,
  writableTmpDirAsHomeHook,
  # TODO: livekit-libwebrtc - not yet packaged
  # TODO: envsubst - not yet available (part of gettext in nixpkgs, standalone in zed)
  # TODO: cargo-bundle - not yet packaged (only needed for darwin)
  # TODO: lld - not yet packaged (only needed for darwin)
  # TODO: buildFHSEnv - not yet available (FHS wrapper omitted)
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-editor";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZUb6DhjlaOQbwsx7Tf7WEtflzZhGUXxFxvMrRwxatj0=";
  };

  postPatch = ''
    # Disable upstream's rustflags overrides to avoid linker issues
    rm .cargo/config.toml

    # The generate-licenses script wants a specific version of cargo-about eventhough
    # newer versions work just as well.
    substituteInPlace script/generate-licenses \
      --replace-fail '$CARGO_ABOUT_VERSION' '${cargo-about.version}'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # webrtc-sys expects glib headers to be in the sysroot, so we have to point it in the right direction
    substituteInPlace $cargoDepsCopy/*/webrtc-sys-*/build.rs \
      --replace-fail 'builder.include(&glib_path);' 'builder.include("${lib.getInclude glib}/include/glib-2.0");' \
      --replace-fail 'builder.include(&glib_path_config);' 'builder.include("${lib.getLib glib}/lib/glib-2.0/include");'
  '';

  cargoHash = "sha256-prcAPH9jA8/drWBPblXHbBYCB0OryZ4JhgPPArPKxoE=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    cargo-about
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeBinaryWrapper ];

  # zed uses cmake via rust build scripts (e.g. cmake-rs crate), not as the top-level build system
  dontUseCmakeConfigure = true;

  buildInputs = [
    libgit2
    sqlite
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    openssl
    glib
    alsa-lib
    libxkbcommon
    wayland
    libxcb
    # required by livekit:
    libGL
    libx11
    libxext
  ];

  cargoBuildFlags = [
    "--package=zed"
    "--package=cli"
  ];

  # Some crates define extra types or enum values in test configuration which then lead
  # to type checking errors in other crates unless this feature is enabled.
  checkFeatures = [
    "visual-tests"
  ];

  env = {
    ALLOW_MISSING_LICENSES = true;
    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = true;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
    # Setting this environment variable allows to disable auto-updates
    ZED_UPDATE_EXPLANATION = "Zed has been installed using Nix. Auto-updates have thus been disabled.";
    # Used by `zed --version`
    RELEASE_VERSION = finalAttrs.version;
    # TODO: LK_CUSTOM_WEBRTC = livekit-libwebrtc;
  };

  preBuild = ''
    bash script/generate-licenses
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/libexec/zed-editor --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }
    wrapProgram $out/libexec/zed-editor --suffix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  useNextest = true;

  installPhase = ''
    runHook preInstall

    release_target="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 $release_target/zed $out/libexec/zed-editor
    install -Dm755 $release_target/cli $out/bin/zeditor

    install -Dm644 $src/crates/zed/resources/app-icon@2x.png $out/share/icons/hicolor/512x512@2/apps/zed.png
    install -Dm644 $src/crates/zed/resources/app-icon.png $out/share/icons/hicolor/512x512/apps/zed.png

    # TODO: desktop file generation requires envsubst
    # (
    #   export DO_STARTUP_NOTIFY="true"
    #   export APP_CLI="zeditor"
    #   export APP_ICON="zed"
    #   export APP_NAME="Zed"
    #   export APP_ARGS="%U"
    #   mkdir -p "$out/share/applications"
    #   envsubst < "crates/zed/resources/zed.desktop.in" > "$out/share/applications/dev.zed.Zed.desktop"
    # )
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "zeditor";
    platforms = lib.platforms.linux;
  };
})
