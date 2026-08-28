{
  lib,
  addDriverRunpath,
  alsa-lib,
  bash,
  docutils,
  fetchFromGitHub,
  ffmpeg,
  freefont_ttf,
  freetype,
  lcms2,
  libGL,
  libx11,
  libxscrnsaver,
  libxext,
  libxpresent,
  libxrandr,
  libarchive,
  libass,
  libbluray,
  libcaca,
  libdrm,
  libdisplay-info,
  libdvdnav,
  libdvdread,
  libjack2,
  libplacebo,
  libpthread-stubs,
  libpulseaudio,
  libuchardet,
  libva,
  libvdpau,
  libxkbcommon,
  lua,
  libgbm,
  meson,
  mujs,
  ninja,
  nv-codec-headers ? null,
  openal-soft,
  pipewire,
  pkg-config,
  python3,
  rubberband,
  shaderc,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zimg,

  alsaSupport ? stdenv.hostPlatform.isLinux,
  archiveSupport ? true,
  bluraySupport ? true,
  cacaSupport ? true,
  cmsSupport ? true,
  drmSupport ? stdenv.hostPlatform.isLinux,
  dvbinSupport ? stdenv.hostPlatform.isLinux,
  dvdnavSupport ? true,
  jackaudioSupport ? false,
  javascriptSupport ? true,
  openalSupport ? true,
  pipewireSupport ? false,
  pulseSupport ? true,
  rubberbandSupport ? true,
  sdl2Support ? false,
  vaapiSupport ? true,
  vdpauSupport ? true,
  vulkanSupport ? true,
  waylandSupport ? true,
  x11Support ? true,
  zimgSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpv";
  version = "0.41.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gJWqfvPE6xOKlgj2MzZgXiyOKxksJlY/tL6T/BeG19c=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "conf_data.set_quoted('CONFIGURATION', meson.build_options())" \
                     "conf_data.set_quoted('CONFIGURATION', '<omitted>')"

    pushd TOOLS
    mv mpv_identify.sh mpv_identify
    patchShebangs *.py *.sh
    mv mpv_identify mpv_identify.sh
    popd
  '';

  mesonFlags = [
    (lib.mesonOption "default_library" "shared")
    (lib.mesonOption "sysconfdir" "/etc")
    (lib.mesonBool "libmpv" true)
    (lib.mesonEnable "manpage-build" true)
    (lib.mesonEnable "cdda" false)
    (lib.mesonEnable "dvbin" dvbinSupport)
    (lib.mesonEnable "dvdnav" dvdnavSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "sdl2-audio" sdl2Support)
    (lib.mesonEnable "sdl2-gamepad" sdl2Support)
    (lib.mesonEnable "sdl2-video" sdl2Support)
  ];

  mesonAutoFeatures = "auto";

  nativeBuildInputs = [
    addDriverRunpath
    docutils
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ]
  ++ lib.optionals waylandSupport [ wayland-scanner ];

  buildInputs = [
    bash
    ffmpeg
    freetype
    libass
    libplacebo
    libpthread-stubs
    libuchardet
    lua
    python3
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals archiveSupport [ libarchive ]
  ++ lib.optionals bluraySupport [ libbluray ]
  ++ lib.optionals cacaSupport [ libcaca ]
  ++ lib.optionals cmsSupport [ lcms2 ]
  ++ lib.optionals drmSupport [
    libdrm
    libdisplay-info
    libgbm
  ]
  ++ lib.optionals dvdnavSupport [
    libdvdnav
    libdvdread
  ]
  ++ lib.optionals jackaudioSupport [ libjack2 ]
  ++ lib.optionals javascriptSupport [ mujs ]
  ++ lib.optionals openalSupport [ openal-soft ]
  ++ lib.optionals pipewireSupport [ pipewire ]
  ++ lib.optionals pulseSupport [ libpulseaudio ]
  ++ lib.optionals rubberbandSupport [ rubberband ]
  ++ lib.optionals vaapiSupport [ libva ]
  ++ lib.optionals vdpauSupport [ libvdpau ]
  ++ lib.optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    libxkbcommon
  ]
  ++ lib.optionals x11Support [
    libx11
    libxext
    libGL
    libxrandr
    libxpresent
    libxscrnsaver
  ]
  ++ lib.optionals zimgSupport [ zimg ]
  ++ lib.optionals (nv-codec-headers != null) [ nv-codec-headers ];

  postInstall = ''
    mkdir -p $out/share/mpv
    ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

    pushd ../TOOLS
    cp mpv_identify.sh umpv $out/bin/
    popd

    pushd $out/share/applications
    sed -e '/Icon=/ ! s|mpv|umpv|g; s|^Exec=.*|Exec=umpv %U|' \
      mpv.desktop > umpv.desktop
    printf "NoDisplay=true\n" >> umpv.desktop
    printf "StartupNotify=false\n" >> umpv.desktop
    popd
  '';

  postFixup = ''
    addDriverRunpath $out/bin/mpv
    patchShebangs --update --host $out/bin/umpv $out/bin/mpv_identify.sh
  '';

  doCheck = false;

  meta = {
    homepage = "https://mpv.io";
    description = "General-purpose media player, fork of MPlayer and mplayer2";
    changelog = "https://github.com/mpv-player/mpv/releases/tag/v${finalAttrs.version}";
    license = [
      lib.licenses.gpl2Plus
      lib.licenses.lgpl21Plus
    ];
    mainProgram = "mpv";
    platforms = lib.platforms.linux;
  };
})
