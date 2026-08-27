{
  stdenv,
  lib,
  # TODO: rustPlatform not yet available in ekapkgs
  rustPlatform,
  fetchFromGitLab,
  # TODO: cargo not yet available in ekapkgs
  # cargo,
  meson,
  ninja,
  gettext,
  pkg-config,
  # TODO: rustc not yet available in ekapkgs
  # rustc,
  glib,
  gtk4,
  libadwaita,
  appstream-glib,
  desktop-file-utils,
  dbus,
  # TODO: openssl not yet ported to ekapkgs
  openssl,
  glib-networking,
  # TODO: sqlite not yet ported to ekapkgs
  sqlite,
  gst_all_1,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-podcasts";
  version = "25.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    tag = finalAttrs.version;
    hash = "sha256-SblEHmKB/WZwT3T3vnlB4yJjY9JhftDkO21/yY//BRM=";
  };

  # TODO: cargoDeps requires rustPlatform.fetchCargoVendor
  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit (finalAttrs) pname version src;
  #   hash = "sha256-Ii5M6W5v5t+qppQNZI1ypHGMM5urUMv7e3Fef3FjfAA=";
  # };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # TODO: cargo not yet available in ekapkgs
    # cargo
    # TODO: rustPlatform.cargoSetupHook not yet available in ekapkgs
    # rustPlatform.cargoSetupHook
    # TODO: rustc not yet available in ekapkgs
    # rustc
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gettext
    dbus
    openssl
    glib-networking
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  # tests require network
  doCheck = false;

  meta = {
    description = "Listen to your favorite podcasts";
    mainProgram = "gnome-podcasts";
    homepage = "https://apps.gnome.org/Podcasts/";
    changelog = "https://gitlab.gnome.org/World/podcasts/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
