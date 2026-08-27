{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  meson,
  ninja,
  pkg-config,
  wf-config,
  cairo,
  libGL,
  libdrm,
  libexecinfo,
  libevdev,
  libinput,
  libjpeg,
  libxkbcommon,
  libxml2,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  pango,
  libxcb-wm,
  yyjson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.11.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-G6GakEpnqw3xORXP7mr2YoyAEymozV0CYeof+a1Nh74=";
  };

  postPatch = ''
    substituteInPlace plugins/common/wayfire/plugins/common/cairo-util.hpp \
      --replace "<drm_fourcc.h>" "<libdrm/drm_fourcc.h>"
  '';

  nativeBuildInputs = [
    cmake
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    doctest
    libGL
    libdrm
    libexecinfo
    libevdev
    libinput
    libjpeg
    libxkbcommon
    libxml2
    vulkan-headers
    wayland-protocols
    libxcb-wm
    yyjson
  ];

  # CMake is just used for finding doctest
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    wf-config
    wlroots
    wayland
    cairo
    pango
  ];

  env.NIX_CFLAGS_COMPILE = "-isystem ${libdrm.dev}/include/libdrm";

  mesonBuildType = "release";

  mesonFlags = [
    "--sysconfdir /etc"
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=enabled"
    # TODO: xwayland currently fails to build (libtirpc broken); disable until fixed
    (lib.mesonEnable "xwayland" false)
    (lib.mesonEnable "wf-touch:tests" false)
  ];

  passthru.providedSessions = [ "wayfire" ];

  meta = {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
