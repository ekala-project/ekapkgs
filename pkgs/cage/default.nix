{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  scdoc,
  makeWrapper,
  wlroots,
  wayland,
  wayland-protocols,
  pixman,
  libxkbcommon,
  libxcb-wm,
  libGL,
  libx11,
  xwayland ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cage";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "cage-kiosk";
    repo = "cage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FHIOicRBL881Kvvui4HTKy0g7K9HcQ0ineLECh6MqFI=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    scdoc
    makeWrapper
  ];

  buildInputs = [
    wlroots
    wayland
    wayland-protocols
    pixman
    libxkbcommon
    libxcb-wm
    libGL
    libx11
  ];

  mesonBuildType = "release";

  postFixup = lib.optionalString wlroots.enableXWayland ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  meta = {
    description = "Wayland kiosk that runs a single, maximized application";
    homepage = "https://www.hjdskes.nl/projects/cage/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "cage";
  };
})
