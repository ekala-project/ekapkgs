{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-layer-shell";
  version = "0.9.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TObAo/YgS6ObYrNLitxMwneGzLxwnnBIOhBVAeAzbt4=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    gtk3
  ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dexamples=true"
    "-Dintrospection=false"
    "-Dvapi=false"
  ];

  meta = with lib; {
    description = "Library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    mainProgram = "gtk-layer-demo";
    homepage = "https://github.com/wmww/gtk-layer-shell";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
})
