{
  stdenv,
  lib,
  fetchFromGitHub,
  cairo,
  libxkbcommon,
  pango,
  fribidi,
  harfbuzz,
  pkg-config,
  scdoc,
  ncurses,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxinerama,
  libxft,
  libxdmcp,
  libx11,
  libpthread-stubs,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bemenu";
  version = "0.6.23";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "bemenu";
    rev = finalAttrs.version;
    hash = "sha256-0vpqJ2jydTt6aVni0ma0g+80PFz+C4xJ5M77sMODkSg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    fribidi
    harfbuzz
    libxkbcommon
    pango
    ncurses
    wayland
    wayland-protocols
    libx11
    libxinerama
    libxft
    libxdmcp
    libpthread-stubs
    libxcb
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [
    "clients"
    "curses"
    "wayland"
    "x11"
  ];

  meta = {
    homepage = "https://github.com/Cloudef/bemenu";
    description = "Dynamic menu library and client program inspired by dmenu";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bemenu";
    platforms = lib.platforms.linux;
  };
})
