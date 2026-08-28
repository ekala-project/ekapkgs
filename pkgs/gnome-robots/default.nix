{
  lib,
  stdenv,
  # TODO: cargo not yet available
  desktop-file-utils,
  fetchurl,
  glib,
  gtk4,
  itstool,
  libadwaita,
  # TODO: libglycin not yet available
  # TODO: libglycin-gtk4 not yet available
  # TODO: gst_all_1 (gstreamer, gst-plugins-base, gst-plugins-good) not yet available
  meson,
  ninja,
  pkg-config,
  # TODO: rustc not yet available
  # TODO: rustPlatform not yet available
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-robots";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-robots/${lib.versions.major finalAttrs.version}/gnome-robots-${finalAttrs.version}.tar.xz";
    hash = "sha256-YX5XTBX5Bhi4JJPJk51xdZatLOH/HeCq1cnDl2Yz03k=";
  };

  # TODO: cargoDeps requires rustPlatform.fetchCargoVendor
  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit (finalAttrs) pname version src;
  #   hash = "sha256-T3o4zlRLQzrLexSDI9A98bubehYFwJY1zBVUUNmrc9o=";
  # };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    # TODO: cargo not yet available
    # TODO: rustc not yet available
    # TODO: rustPlatform.cargoSetupHook not yet available
    gtk4 # for gtk4-update-icon-cache
    wrapGAppsHook4
    itstool
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    # TODO: libglycin not yet available
    # TODO: libglycin-gtk4 not yet available
    # TODO: gst_all_1.gstreamer not yet available (sound playback)
    # TODO: gst_all_1.gst-plugins-base not yet available
    # TODO: gst_all_1.gst-plugins-good not yet available
  ];

  # TODO: uncomment when gstreamer deps are available
  # preFixup = ''
  #   # Seal GStreamer plug-ins so that we can notice when they are missing.
  #   gappsWrapperArgs+=(--set "GST_PLUGIN_SYSTEM_PATH_1_0" "$GST_PLUGIN_SYSTEM_PATH_1_0")
  #   unset GST_PLUGIN_SYSTEM_PATH_1_0
  # '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-robots";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-robots/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Avoid the robots and make them crash into each other";
    mainProgram = "gnome-robots";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
