{
  lib,
  stdenv,
  alsa-lib,
  dbus,
  fetchFromGitHub,
  ffmpeg,
  flac,
  freetype,
  gamemode,
  libdrm,
  libGL,
  libGLU,
  libpulseaudio,
  libv4l,
  libx11,
  libxdmcp,
  libxext,
  libxkbcommon,
  libxml2,
  libxxf86vm,
  makeBinaryWrapper,
  mbedtls,
  libgbm,
  nvidia_cg_toolkit,
  pipewire,
  pkg-config,
  python3,
  qt6,
  sdl2-compat,
  spirv-tools,
  udev,
  vulkan-loader,
  wayland,
  wayland-scanner,
  gtk3,
  zlib,
  enableNvidiaCgToolkit ? false,
  withGamemode ? stdenv.hostPlatform.isLinux,
  withVulkan ? stdenv.hostPlatform.isLinux,
  withWayland ? stdenv.hostPlatform.isLinux,
}:

let
  runtimeLibs =
    lib.optional withVulkan vulkan-loader ++ lib.optional withGamemode (lib.getLib gamemode);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "retroarch-bare";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "RetroArch";
    hash = "sha256-+3jgoh6OVbPzW5/nCvpB1CRgkMTBxLkYMm6UV16/cfU=";
    rev = "v${finalAttrs.version}";
  };

  nativeBuildInputs = [
    pkg-config
    qt6.wrapQtAppsHook
    gtk3.wrapGAppsHook
  ]
  ++ lib.optional withWayland wayland
  ++ lib.optional (runtimeLibs != [ ]) makeBinaryWrapper;

  buildInputs = [
    ffmpeg.v7
    flac
    freetype
    libGL
    libGLU
    libxml2
    mbedtls
    python3
    qt6.qtbase
    sdl2-compat
    spirv-tools
    zlib
  ]
  ++ lib.optional enableNvidiaCgToolkit nvidia_cg_toolkit
  ++ lib.optional withVulkan vulkan-loader
  ++ lib.optionals withWayland [
    wayland
    wayland-scanner
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    libx11
    libxdmcp
    libxext
    libxxf86vm
    libdrm
    libpulseaudio
    libv4l
    libxkbcommon
    libgbm
    pipewire
    udev
  ];

  configureFlags = [
    "--disable-update_cores"
    "--disable-builtinmbedtls"
    "--enable-systemmbedtls"
    "--disable-builtinzlib"
    # https://github.com/libretro/RetroArch/issues/18370
    # "--disable-builtinflac"
    "--disable-update_assets"
    "--disable-update_core_info"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-dbus"
    "--enable-egl"
    "--enable-kms"
  ];

  postInstall =
    lib.optionalString (runtimeLibs != [ ]) ''
      wrapProgram $out/bin/retroarch \
        --prefix LD_LIBRARY_PATH ':' ${lib.makeLibraryPath runtimeLibs}
    ''
    + lib.optionalString enableNvidiaCgToolkit ''
      wrapProgram $out/bin/retroarch-cg2glsl \
        --prefix PATH ':' ${lib.makeBinPath [ nvidia_cg_toolkit ]}
    ''
    + ''
      mkdir -p $out/share/icons/hicolor/scalable
      mv $out/share/{pixmaps,icons/hicolor/scalable/apps}
    '';

  preFixup = lib.optionalString (!enableNvidiaCgToolkit) ''
    rm $out/bin/retroarch-cg2glsl
    rm $out/share/man/man6/retroarch-cg2glsl.6*
  '';

  meta = {
    homepage = "https://libretro.com";
    description = "Multi-platform emulator frontend for libretro cores";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    changelog = "https://github.com/libretro/RetroArch/blob/v${finalAttrs.version}/CHANGES.md";
    mainProgram = "retroarch";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
