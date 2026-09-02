{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  desktop-file-utils,
  wrapGAppsHook3,
  glib,
  gtk3,
  libsecret,
  libxml2,
  # TODO: libhandy - not available
  # TODO: gtk-vnc - not available
  # TODO: gtk-frdp - not available
  # TODO: spice-gtk - not available
  # TODO: spice-protocol - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-connections";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-connections/${lib.versions.major finalAttrs.version}/gnome-connections-${finalAttrs.version}.tar.xz";
    hash = "sha256-Vnv2NcbTA66Ex083yE35+4/Pal6d/0UuFBTGcXRNldA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    gettext
    itstool
    desktop-file-utils
    glib # glib-compile-resources
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    # TODO: gtk-vnc
    gtk3
    # TODO: libhandy
    libsecret
    libxml2
    # TODO: gtk-frdp
    # TODO: spice-gtk
    # TODO: spice-protocol
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-connections";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-connections/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Remote desktop client for the GNOME desktop environment";
    mainProgram = "gnome-connections";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
