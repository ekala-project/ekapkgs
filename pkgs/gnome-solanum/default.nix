{
  lib,
  stdenv,
  fetchFromGitLab,
  # TODO: rustPlatform not yet available in ekapkgs
  rustPlatform,
  # TODO: cargo not yet available in ekapkgs
  # cargo,
  desktop-file-utils,
  appstream-glib,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  # TODO: rustc not yet available in ekapkgs
  # rustc,
  wrapGAppsHook4,
  python3,
  glib,
  gtk4,
  gst_all_1,
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

  # TODO: cargoDeps requires rustPlatform.fetchCargoVendor
  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit (finalAttrs) pname version src;
  #   hash = "sha256-krjbeutochFk5md+THlYBW4iEwfFDbK89DYHZyd3IKo=";
  # };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    python3
    # TODO: git needed at build time but typically available
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    # TODO: rustPlatform.cargoSetupHook not yet available in ekapkgs
    # rustPlatform.cargoSetupHook
    # TODO: cargo not yet available in ekapkgs
    # cargo
    # TODO: rustc not yet available in ekapkgs
    # rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "Pomodoro timer for the GNOME desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "solanum";
  };
})
