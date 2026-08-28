{
  lib,
  stdenv,
  fetchurl,
  freeglut,
  libGL,
  libGLU,
  libX11,
  libXext,
  libgbm,
  mesa,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  vulkan-loader,
  libxkbcommon,
  glslang,
  libxcb,
  libdecor,
}:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "9.0.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/${pname}-${version}.tar.xz";
    sha256 = "sha256-MEaj0mp7BRr3690lel8jv+sWDK1u2VIynN/x6fHtSWs=";
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
    glslang
  ];

  buildInputs = [
    freeglut
    libX11
    libXext
    libGL
    libGLU
    libgbm
    libxcb
    wayland
    wayland-protocols
    vulkan-loader
    libxkbcommon
    libdecor
  ];

  mesonFlags = [
    "-Degl=auto"
    (lib.mesonEnable "libdrm" true)
    (lib.mesonEnable "osmesa" false)
    (lib.mesonEnable "wayland" true)
  ];

  meta = {
    inherit (mesa.meta) homepage platforms;
    description = "Collection of demos and test programs for OpenGL and Mesa";
    license = lib.licenses.mit;
  };
}
