{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gi-docgen,
  docbook-xsl-nons,
  gettext,
  blueprint-compiler,
  desktop-file-utils,
  wayland-scanner,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  libportal,
  gnome-autoar,
  glib-networking,
  icu,
  shared-mime-info,
  libnotify,
  libexif,
  # TODO: libglycin, libglycin-gtk4 (not yet available)
  libseccomp,
  librsvg,
  tinysparql,
  localsearch,
  gexiv2,
  libselinux,
  libcloudproviders,
  gdk-pixbuf,
  gnome-desktop,
  gst_all_1,
  gsettings-desktop-schemas,
  gnome-user-share,
  gobject-introspection,
  glib,
  libjxl,
  webp-pixbuf-loader,
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
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gi-docgen
    docbook-xsl-nons
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    gexiv2
    glib-networking
    icu
    gnome-desktop
    gsettings-desktop-schemas
    gnome-user-share
    gst_all_1.gst-plugins-base
    gtk4
    libadwaita
    libportal.gtk4
    libexif
    libnotify
    libseccomp
    libselinux
    gdk-pixbuf
    libcloudproviders
    shared-mime-info
    tinysparql
    localsearch
    gnome-autoar
    # TODO: libglycin, libglycin-gtk4 (not yet available)
    glib
  ];

  propagatedBuildInputs = [
    gtk4
  ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dtests=none"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${libjxl}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  meta = {
    description = "File manager for GNOME";
    homepage = "https://apps.gnome.org/Nautilus/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "nautilus";
  };
})
