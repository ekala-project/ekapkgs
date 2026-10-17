{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  rustPlatform,
  systemdMinimal,
  symlinkJoin,

  # nativeBuildInputs
  blueprint-compiler,
  cargo,
  makeWrapper,
  libxml2,
  meson,
  ninja,
  pkg-config,
  protobuf,
  python3,
  rustc,
  wrapGAppsHook4,

  # buildInputs
  appstream-glib,
  cairo,
  cmake,
  dbus,
  desktop-file-utils,
  gdk-pixbuf,
  gettext,
  glib,
  graphene,
  gtk4,
  libadwaita,
  libdrm,
  libgbm,
  pango,
  sqlite,
  udev,
  wayland,

  # magpie wrapper
  addDriverRunpath,
  libGL,
  vulkan-loader,
}:

let
  nvtop = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    rev = "3d4a953da02bc18886734613bb9f60ff80669de7";
    hash = "sha256-yBCJZt23NIjXYXLQAY9Go3bcwzxyUnL+3TP9kyFthr0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mission-center";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "mission-center-devs";
    repo = "mission-center";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RJdIyDcmOBlKTjqzNOsSN6I6v7Nx7qjgNLgd+bc2vME=";
  };

  postPatch = ''
    substituteInPlace src/magpie_client/client.rs \
      --replace-fail \
        '"missioncenter-magpie"' \
        '"${placeholder "out"}/bin/missioncenter-magpie"'

    SRC_DIR=$NIX_BUILD_TOP/source
    SRC_MAGPIE_DIR=$SRC_DIR/subprojects/magpie
    SRC_NVTOP_DIR=$SRC_MAGPIE_DIR/platform-linux/3rdparty/nvtop
  ''
  + ''
    substituteInPlace "$SRC_NVTOP_DIR/nvtop.json" \
      --replace-fail "nvtop-${nvtop.rev}" "nvtop-src"

    DEST_NVTOP_DIR=$SRC_DIR/build/subprojects/magpie/src/debug/build/native/nvtop-src

    mkdir -p "$DEST_NVTOP_DIR"
    cp -r --no-preserve=mode,ownership "${nvtop}"/* "$DEST_NVTOP_DIR"

    pushd "$DEST_NVTOP_DIR"
    mkdir -p include/libdrm
  ''
  + ''
    for patchfile in "$SRC_NVTOP_DIR"/patches/nvtop*.patch; do
      patch -p1 --forward < "$patchfile" || true
    done
    popd
  ''
  + ''
    patchShebangs $SRC_MAGPIE_DIR/platform-linux/hwdb/generate_hwdb.py
  ''
  + ''
    substituteInPlace subprojects/magpie/platform-linux/src/memory.rs \
      --replace-fail "udevadm" "${lib.getExe' systemdMinimal "udevadm"}"
  '';

  cargoDeps =
    let
      missionCenterCargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-G48wiOa82hCX/xl6DQeWxLNZ6PAfzqfxzl/Srra004E=";
      };
      magpieCargoDeps = rustPlatform.fetchCargoVendor {
        pname = "${finalAttrs.pname}-magpie";
        inherit (finalAttrs) version src;
        sourceRoot = "${finalAttrs.src.name}/subprojects/magpie";
        hash = "sha256-WwUyPgP47O5i8+1XZciH/FCLAWz9/LRmJtgkhSPJwiY=";
      };
    in
    symlinkJoin {
      name = "cargo-vendor-dir";
      paths = [
        missionCenterCargoDeps
        magpieCargoDeps
      ];
      postBuild = ''
        rm -f $out/.cargo/config.toml
        cp ${magpieCargoDeps}/.cargo/config.toml $out/.cargo/config.toml
      '';
    };

  nativeBuildInputs = [
    cmake
    addDriverRunpath
    blueprint-compiler
    cargo
    libxml2
    makeWrapper
    meson
    ninja
    pkg-config
    python3
    protobuf
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    appstream-glib
    blueprint-compiler
    cairo
    dbus
    desktop-file-utils
    gdk-pixbuf
    gettext
    glib
    graphene
    gtk4
    libadwaita
    libdrm
    libgbm
    pango
    sqlite
    udev
    wayland
  ];

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/bin/missioncenter \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/missioncenter-magpie \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libdrm
          vulkan-loader
          addDriverRunpath.driverLink
        ]
      }"
  '';

  meta = {
    description = "Monitor your CPU, Memory, Disk, Network and GPU usage";
    homepage = "https://gitlab.com/mission-center-devs/mission-center";
    changelog = "https://gitlab.com/mission-center-devs/mission-center/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "missioncenter";
  };
})
