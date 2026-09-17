{
  stdenv,
  lib,
  fetchurl,
  replaceVars,
  pkg-config,
  meson,
  ninja,
  gettext,
  wrapGAppsHook4,
  glib,
  appstream,
  libsoup_3,
  libadwaita,
  gtk4,
  gsettings-desktop-schemas,
  gnome-desktop,
  json-glib,
  glib-networking,
  libsecret,
  flatpak,
  gobject-introspection,
  itstool,
  desktop-file-utils,
  gst_all_1,
  # TODO: packagekit - not available
  ostree,
  polkit,
  isocodes,
  gspell,
  libxslt,
  libgudev,
  libxmlb,
  # TODO: malcontent - not available
  libsysprof-capture,
  # TODO: valgrind-light - not available
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  docbook_xml_dtd_43,
  gtk-doc,
  fwupd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-software";
  version = "50.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major finalAttrs.version}/gnome-software-${finalAttrs.version}.tar.xz";
    hash = "sha256-sTGOaPArs5AvzY+QTVbwP1NOpQmPZeTGu5wskk2n+CM=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit isocodes;
    })
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    libxslt
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    # TODO: valgrind-light - not available
    docbook-xsl-nons
    gtk-doc
    desktop-file-utils
    gobject-introspection
    itstool
  ];

  buildInputs = [
    gtk4
    glib
    glib-networking
    # TODO: packagekit - not available
    appstream
    libsoup_3
    libadwaita
    gsettings-desktop-schemas
    gnome-desktop
    gspell
    json-glib
    libsecret
    ostree
    polkit
    flatpak
    libgudev
    libxmlb
    # TODO: malcontent - not available
    libsysprof-capture
    # For video screenshots
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  mesonFlags = [
    # Requires /etc/machine-id, D-Bus system bus, etc.
    "-Dtests=false"
  ];

  meta = {
    description = "Software store that lets you install and update applications and system extensions";
    mainProgram = "gnome-software";
    homepage = "https://apps.gnome.org/Software/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
