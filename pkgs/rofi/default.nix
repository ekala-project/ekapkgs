{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxkbcommon,
  pango,
  which,
  git,
  cairo,
  libxcb,
  xcb-util-cursor,
  libxcb-keysyms,
  xcbutil,
  libxcb-wm,
  xcbutilxrm,
  libstartup_notification,
  bison,
  flex,
  librsvg,
  check,
  glib,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "rofi";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-akKwIYH9OoCh4ZE/bxKPCppxXsUhplvfRjSGsdthFk4=";
  };

  preConfigure = ''
    patchShebangs "script"
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    flex
    bison
    wayland-scanner
  ];

  buildInputs = [
    libxkbcommon
    pango
    cairo
    git
    librsvg
    check
    libstartup_notification
    libxcb
    xcb-util-cursor
    libxcb-keysyms
    xcbutil
    libxcb-wm
    xcbutilxrm
    which
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    "-Dimdkit=false"
    "-Ddrun=true"
    "-Dcheck=disabled"
  ];

  doCheck = false;

  meta = {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "rofi";
  };
}
