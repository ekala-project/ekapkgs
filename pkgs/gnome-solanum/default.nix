{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  rustc,
  python3,
  glib,
  gtk4,
  gstreamer,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solanum";
  version = "6.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
    tag = finalAttrs.version;
    hash = "sha256-Wh9/88Vc4mtjL0U1Vrw+GEEBPjEv+5NrWd/Kw1glp+w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-krjbeutochFk5md+THlYBW4iEwfFDbK89DYHZyd3IKo=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gtk4.wrapGAppsHook
    python3
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-bad
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "Pomodoro timer for the GNOME desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "solanum";
  };
})
