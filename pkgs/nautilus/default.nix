{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  # TODO: gi-docgen (not yet ported)
  # TODO: docbook-xsl-nons (not yet ported)
  gettext,
  # TODO: blueprint-compiler (not yet ported)
  desktop-file-utils,
  wayland-scanner,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  # TODO: libportal-gtk4 (not available)
  gnome-autoar,
  # TODO: glib-networking (not yet ported)
  icu,
  # TODO: shared-mime-info (not yet ported)
  libnotify,
  # TODO: libexif (not yet ported)
  # TODO: libglycin, libglycin-gtk4 (not yet ported)
  # TODO: libseccomp (not yet ported)
  # TODO: librsvg (not yet ported)
  # TODO: tinysparql (being ported)
  # TODO: localsearch (not available)
  gexiv2,
  # TODO: libselinux (not yet ported)
  # TODO: libcloudproviders (not available)
  gdk-pixbuf,
  gnome-desktop,
  gst_all_1,
  gsettings-desktop-schemas,
  # TODO: gnome-user-share (circular dep - this file; wire up after both are built)
  gobject-introspection,
  glib,
  # TODO: libjxl (not yet ported) - used in preFixup for thumbnailers
  # TODO: webp-pixbuf-loader (not yet ported) - used in preFixup for thumbnailers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus";
  version = "50.2.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${lib.versions.major finalAttrs.version}/nautilus-${finalAttrs.version}.tar.xz";
    hash = "sha256-4eKF7930LtMN2lsp9/jSQtq0vBQJqQVIY7NnutSzTVo=";
  };

  patches = [
    # Allow changing extension directory using environment variable.
    ./extension_dir.patch
  ];

  nativeBuildInputs = [
    # TODO: blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    # TODO: gi-docgen
    # TODO: docbook-xsl-nons
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2
    # TODO: glib-networking
    icu
    gnome-desktop
    # TODO: adwaita-icon-theme (not yet ported as build dep)
    gsettings-desktop-schemas
    # TODO: gnome-user-share
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    # TODO: libportal-gtk4 (not available)
    # TODO: libexif
    libnotify
    # TODO: libseccomp
    # TODO: libselinux
    gdk-pixbuf
    # TODO: libcloudproviders (not available)
    # TODO: shared-mime-info
    # TODO: tinysparql (being ported)
    # TODO: localsearch (not available)
    gnome-autoar
    # TODO: libglycin, libglycin-gtk4
    glib
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dtests=none"
  ];

  # TODO: add preFixup for thumbnailer XDG_DATA_DIRS once librsvg,
  # libjxl, webp-pixbuf-loader, shared-mime-info are available

  meta = {
    description = "File manager for GNOME";
    homepage = "https://apps.gnome.org/Nautilus/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "nautilus";
  };
})
