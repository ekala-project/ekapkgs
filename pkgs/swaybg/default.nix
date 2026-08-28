{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  gdk-pixbuf,
  wrapGAppsNoGuiHook,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swaybg";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ByocNDqkv1ufN3Rr5yrfGkN5zS+Cw1e8QLQ+5opc1K4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
    wayland-scanner
    wrapGAppsNoGuiHook
    gdk-pixbuf
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    gdk-pixbuf
    librsvg
  ];

  mesonFlags = [
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  meta = {
    description = "Wallpaper tool for Wayland compositors";
    homepage = "https://github.com/swaywm/swaybg";
    license = lib.licenses.mit;
    mainProgram = "swaybg";
    platforms = lib.platforms.linux;
  };
})
