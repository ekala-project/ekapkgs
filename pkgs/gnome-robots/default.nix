{
  lib,
  stdenv,
  cargo,
  desktop-file-utils,
  fetchurl,
  glib,
  gstreamer,
  gtk4,
  itstool,
  libadwaita,
  # TODO: libglycin - not available
  # TODO: libglycin-gtk4 - not available
  meson,
  ninja,
  pkg-config,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-robots";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major finalAttrs.version}/gnome-robots-${finalAttrs.version}.tar.xz";
    hash = "sha256-YX5XTBX5Bhi4JJPJk51xdZatLOH/HeCq1cnDl2Yz03k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-T3o4zlRLQzrLexSDI9A98bubehYFwJY1zBVUUNmrc9o=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    cargo
    rustc
    rustPlatform.cargoSetupHook
    gtk4 # for gtk4-update-icon-cache
    gtk4.wrapGAppsHook
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    # TODO: libglycin - not available
    # TODO: libglycin-gtk4 - not available
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
  ];

  preFixup = ''
    # Seal GStreamer plug-ins so that we can notice when they are missing.
    gappsWrapperArgs+=(--set "GST_PLUGIN_SYSTEM_PATH_1_0" "$GST_PLUGIN_SYSTEM_PATH_1_0")
    unset GST_PLUGIN_SYSTEM_PATH_1_0
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-robots";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-robots/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Avoid the robots and make them crash into each other";
    mainProgram = "gnome-robots";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
