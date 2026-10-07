{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  cairo,
  libGL,
  libdisplay-info_0_3 ? null,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  libgbm,
  seatd,
  wayland,
  wayland-protocols,
  libxcb-cursor,
  glslang,

  demoSupport ? true,
  jpegSupport ? true,
  libjpeg,
  lcmsSupport ? true,
  lcms2,
  luaSupport ? true,
  lua ? null,
  pangoSupport ? true,
  pango,
  pipewireSupport ? false,
  pipewire,
  rdpSupport ? false,
  freerdp ? null,
  remotingSupport ? false,
  gstreamer,
  vncSupport ? true,
  aml,
  neatvnc,
  pam,
  vulkanSupport ? true,
  vulkan-headers,
  vulkan-loader,
  webpSupport ? true,
  libwebp,
  xwaylandSupport ? (xwayland != null),
  libxcursor,
  xwayland ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "weston";
  version = "16.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wayland";
    repo = "weston";
    rev = finalAttrs.version;
    hash = "sha256-0TBVyqnfd7GMGPAzbYOmDZgv4gF5kxiqaA8+A0+sEqU=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    wayland-scanner
  ]
  ++ lib.optional vulkanSupport glslang;

  buildInputs = [
    cairo
    libGL
    libdrm
    libevdev
    libinput
    libxkbcommon
    libgbm
    seatd
    wayland
    wayland-protocols
  ]
  ++ lib.optional (libdisplay-info_0_3 != null) libdisplay-info_0_3
  ++ lib.optional jpegSupport libjpeg
  ++ lib.optional lcmsSupport lcms2
  ++ lib.optional (luaSupport && lua.v5_4_compat != null) lua.v5_4_compat
  ++ lib.optional pangoSupport pango
  ++ lib.optional pipewireSupport pipewire
  ++ lib.optional (rdpSupport && freerdp != null) freerdp
  ++ lib.optionals remotingSupport [
    gstreamer
    gstreamer.plugins-base
  ]
  ++ lib.optionals vncSupport [
    aml
    neatvnc
    pam
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optional webpSupport libwebp
  ++ lib.optionals xwaylandSupport [
    libxcursor
    libxcb-cursor
    xwayland
  ];

  mesonEntries = {
    backend-pipewire = pipewireSupport;
    backend-rdp = (rdpSupport && freerdp != null);
    backend-vnc = vncSupport;
    color-management-lcms = lcmsSupport;
    demo-clients = demoSupport;
    image-jpeg = jpegSupport;
    image-webp = webpSupport;
    deprecated-pipewire = pipewireSupport;
    deprecated-remoting = remotingSupport;
    renderer-vulkan = vulkanSupport;
    simple-clients = "";
    shell-lua = (luaSupport && lua.v5_4_compat != null);
    test-junit-xml = false;
    xwayland = xwaylandSupport;
  };

  mesonFlags = lib.optionals (xwaylandSupport && xwayland != null) [
    (lib.mesonOption "xwayland-path" (lib.getExe xwayland))
  ];

  passthru = {
    providedSessions = [ "weston" ];
  };

  meta = {
    description = "Lightweight and functional Wayland compositor";
    longDescription = ''
      Weston is the reference implementation of a Wayland compositor, as well
      as a useful environment in and of itself.
      Out of the box, Weston provides a very basic desktop, or a full-featured
      environment for non-desktop uses such as automotive, embedded, in-flight,
      industrial, kiosks, set-top boxes and TVs. It also provides a library
      allowing other projects to build their own full-featured environments on
      top of Weston's core. A small suite of example or demo clients are also
      provided.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/weston";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "weston";
  };
})
