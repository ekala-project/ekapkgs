{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  qt6,
  gtk3,

  # buildInputs
  bzip2,
  cubeb,
  curl,
  enet,
  ffmpeg,
  fmt,
  glslang,
  gtest,
  hidapi,
  libxdmcp,
  libpulseaudio,
  libspng,
  libusb1,
  lz4,
  lzo,
  miniupnpc,
  minizip-ng,
  openal,
  pugixml,
  sdl3,
  sfml,
  xxhash,
  xz,
  zlib-ng,
  # linux-only
  alsa-lib,
  bluez,
  libGL,
  libxext,
  libxrandr,
  libevdev,
  udev,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolphin-emu";
  version = "2609";

  src = fetchFromGitHub {
    owner = "dolphin-emu";
    repo = "dolphin";
    tag = finalAttrs.version;
    hash = "sha256-mylUTwDBIOIdGKCdA64RSqioTVc9f6oTP5WHAVtkH9w=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git rev-parse HEAD 2>/dev/null >$out/COMMIT
      find $out -name .git -print0 | xargs -0 rm -rf
      popd
    '';
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    bzip2
    cubeb
    curl
    enet
    ffmpeg
    fmt
    glslang
    gtest
    hidapi
    libxdmcp
    libpulseaudio
    libspng
    libusb1
    lz4
    lzo
    miniupnpc
    minizip-ng
    openal
    pugixml
    qt6.qtbase
    qt6.qtsvg
    sdl3
    sfml
    xxhash
    xz
    zlib-ng
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    bluez
    libGL
    libxext
    libxrandr
    libevdev
    udev
    vulkan-loader
  ];

  cmakeEntries = {
    DISTRIBUTOR = "NixOS";
    DOLPHIN_WC_DESCRIBE = finalAttrs.version;
    DOLPHIN_WC_BRANCH = "master";
    CMAKE_POLICY_VERSION_MINIMUM = "3.10";
  };

  preConfigure = ''
    appendToVar cmakeFlags "-DDOLPHIN_WC_REVISION=$(cat COMMIT)"
    rm COMMIT
  '';

  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 $src/Data/51-usb-device.rules $out/etc/udev/rules.d/51-usb-device.rules
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://dolphin-emu.org";
    description = "Gamecube/Wii/Triforce emulator for x86_64 and ARMv8";
    mainProgram = "dolphin-emu";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
