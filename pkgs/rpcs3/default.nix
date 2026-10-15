{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  git,
  qt6Packages,
  openal,
  glew,
  vulkan-headers,
  vulkan-loader,
  libpng,
  libsm,
  ffmpeg,
  libevdev,
  libusb1,
  zlib,
  curl,
  python3,
  pugixml,
  protobuf,
  llvm,
  cubeb,
  opencv4,
  enableDiscordRpc ? false,
  faudioSupport ? true,
  faudio,
  sdl3,
  waylandSupport ? true,
  wayland,
  gtk3,
  miniupnpc,
  rtmidi,
  glslang,
  zstd,
  hidapi,
  vulkan-memory-allocator,
}:

let
  inherit (qt6Packages)
    qtbase
    qtmultimedia
    wrapQtAppsHook
    qtwayland
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rpcs3";
  version = "0.0.42-unstable-2026-08-15";

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = "fc93d932c8560f763f5223c0a4165cc53bceeb3f";
    leaveDotGit = true;
    hash = lib.fakeHash; # TODO: build once to get correct hash
  };

  postUnpack = ''
    cd $sourceRoot/3rdparty
    git submodule update --init \
      fusion/fusion asmjit/asmjit yaml-cpp/yaml-cpp SoundTouch/soundtouch stblib/stb \
      feralinteractive/feralinteractive wolfssl/wolfssl
    cd ../..
  '';

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "ekapkgs-${lib.sources.shortRev finalAttrs.src.rev}"
    #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeEntries = {
    BUILD_SHARED_LIBS = false;
    USE_SYSTEM_ZLIB = true;
    USE_SYSTEM_LIBUSB = true;
    USE_SYSTEM_LIBPNG = true;
    USE_SYSTEM_FFMPEG = true;
    USE_SYSTEM_CURL = true;
    USE_SYSTEM_FAUDIO = true;
    USE_SYSTEM_OPENAL = true;
    USE_SYSTEM_PUGIXML = true;
    USE_SYSTEM_PROTOBUF = true;
    USE_SYSTEM_SDL = true;
    USE_SYSTEM_OPENCV = true;
    USE_SYSTEM_CUBEB = true;
    USE_SYSTEM_MINIUPNPC = true;
    USE_SYSTEM_RTMIDI = true;
    USE_SYSTEM_GLSLANG = true;
    USE_SYSTEM_ZSTD = true;
    USE_SYSTEM_HIDAPI = true;
    USE_SYSTEM_VULKAN_MEMORY_ALLOCATOR = true;
    USE_SDL = true;
    WITH_LLVM = true;
    BUILD_LLVM = false;
    USE_NATIVE_INSTRUCTIONS = false;
    USE_DISCORD_RPC = enableDiscordRpc;
    USE_FAUDIO = faudioSupport;
  };

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    git
    wrapQtAppsHook
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    openal
    glew
    vulkan-headers
    vulkan-loader
    libpng
    ffmpeg
    libevdev
    zlib
    libusb1
    curl
    python3
    pugixml
    sdl3
    protobuf
    llvm
    libsm
    opencv4.cxxdev
    cubeb
    miniupnpc
    rtmidi
    glslang
    zstd
    hidapi
    vulkan-memory-allocator
  ]
  ++ lib.optional faudioSupport faudio
  ++ lib.optionals waylandSupport [
    wayland
    qtwayland
  ];

  doInstallCheck = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    # Taken from https://wiki.rpcs3.net/index.php?title=Help:Controller_Configuration
    install -D ${./99-ds3-controllers.rules} $out/etc/udev/rules.d/99-ds3-controllers.rules
    install -D ${./99-ds4-controllers.rules} $out/etc/udev/rules.d/99-ds4-controllers.rules
    install -D ${./99-dualsense-controllers.rules} $out/etc/udev/rules.d/99-dualsense-controllers.rules
  '';

  meta = {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    license = [
      lib.licenses.gpl2Only
      lib.licenses.gpl3Plus
      lib.licenses.unfree
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "rpcs3";
  };
})
