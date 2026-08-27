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
  # TODO: ostree - not available
  # TODO: polkit - not available
  # TODO: isocodes - not available
  # TODO: gspell - not available
  # TODO: libxslt - not available
  # TODO: libgudev - not available
  # TODO: libxmlb - not available
  # TODO: malcontent - not available
  # TODO: libsysprof-capture - not available
  # TODO: valgrind-light - not available
  # TODO: docbook-xsl-nons - not available
  # TODO: docbook_xml_dtd_42 - not available
  # TODO: docbook_xml_dtd_43 - not available
  # TODO: gtk-doc - not available
  # TODO: fwupd - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-software";
  version = "50.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${lib.versions.major finalAttrs.version}/gnome-software-${finalAttrs.version}.tar.xz";
    hash = "sha256-sTGOaPArs5AvzY+QTVbwP1NOpQmPZeTGu5wskk2n+CM=";
  };

  # TODO: fix-paths.patch requires isocodes (replaceVars)
  # patches = [
  #   (replaceVars ./fix-paths.patch {
  #     inherit isocodes;
  #   })
  # ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    wrapGAppsHook4
    # TODO: libxslt
    # TODO: docbook_xml_dtd_42
    # TODO: docbook_xml_dtd_43
    # TODO: valgrind-light
    # TODO: docbook-xsl-nons
    # TODO: gtk-doc
    desktop-file-utils
    gobject-introspection
    itstool
  ];

  buildInputs = [
    gtk4
    glib
    glib-networking
    # TODO: packagekit
    appstream
    libsoup_3
    libadwaita
    gsettings-desktop-schemas
    gnome-desktop
    # TODO: gspell
    json-glib
    libsecret
    # TODO: ostree
    # TODO: polkit
    flatpak
    # TODO: libgudev
    # TODO: libxmlb
    # TODO: malcontent
    # TODO: libsysprof-capture
    # For video screenshots
    gst_all_1.gst-plugins-base
    # TODO: gst_all_1.gst-plugins-good - not available
  ];

  mesonFlags = [
    # Requires /etc/machine-id, D-Bus system bus, etc.
    "-Dtests=false"
    "-Dfwupd=false"
  ];

  meta = {
    description = "Software store that lets you install and update applications and system extensions";
    mainProgram = "gnome-software";
    homepage = "https://apps.gnome.org/Software/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
