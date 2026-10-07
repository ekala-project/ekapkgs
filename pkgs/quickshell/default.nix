{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  ninja,
  pkg-config,
  spirv-tools,
  vulkan-headers,
  qt6,
  cpptrace,
  jemalloc,
  cli11,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb,
  libdrm,
  libgbm,
  pipewire,
  pam,
  glib,
  polkit,
  layer-shell-qt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quickshell";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "git.outfoxxed.me";
    owner = "quickshell";
    repo = "quickshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gU+VGpwGJ2vvg0mtYqVvj5u+2LteuHlpokH6JSAtueY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    qt6.qtshadertools
    spirv-tools
    vulkan-headers
    wayland-scanner
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    cli11
    wayland
    wayland-protocols
    libdrm
    libgbm
    cpptrace
    jemalloc
    libxcb
    pam
    pipewire
    glib
    polkit
    layer-shell-qt
  ];

  cmakeFlags = [
    "-DDISTRIBUTOR=ekapkgs"
    "-DINSTALL_QML_PREFIX=${qt6.qtbase.qtQmlPrefix}"
    "-DGIT_REVISION=tag-v${finalAttrs.version}"
  ];

  cmakeBuildType = "RelWithDebInfo";
  dontStrip = false;

  meta = {
    description = "Flexible QtQuick based desktop shell toolkit";
    homepage = "https://quickshell.org";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "quickshell";
  };
})
