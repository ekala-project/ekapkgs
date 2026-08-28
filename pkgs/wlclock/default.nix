{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  cmake,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  cairo,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wlclock";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wlclock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-aHA4kXHYH+KvAJSep5X3DqsiK6WFpXr3rGQl/KNiUcY=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    cmake
    cmake.configurePhaseHook
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland-protocols
    wayland
    cairo
  ];

  meta = {
    description = "Digital analog clock for Wayland desktops";
    homepage = "https://git.sr.ht/~leon_plickat/wlclock";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
    mainProgram = "wlclock";
  };
})
