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
}:

stdenv.mkDerivation rec {
  pname = "rofi";
  version = "1.7.9.1";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-HZMVGlK6ig7kWf/exivoiTe9J/SLgjm7VwRm+KgKN44=";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi";
  };
}
