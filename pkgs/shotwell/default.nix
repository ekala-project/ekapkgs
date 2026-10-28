{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  adwaita-icon-theme,
  gtk3,
  libexif,
  libgphoto2,
  libwebp,
  libsoup_3,
  libxml2,
  vala,
  sqlite,
  pkg-config,
  gstreamer,
  libgudev,
  libraw,
  glib,
  glib-networking,
  json-glib,
  gcr_3,
  libgee,
  gexiv2,
  gettext,
  desktop-file-utils,
  gdk-pixbuf,
  librsvg,
  gobject-introspection,
  itstool,
  libsecret,
  libportal-gtk3,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotwell";
  version = "0.32.17";

  src = fetchurl {
    url = "mirror://gnome/sources/shotwell/${lib.versions.majorMinor finalAttrs.version}/shotwell-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-ClZoTpiBfDED9Upkj+lABCfHaiWnsRFFf8HYYMMWdnI=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    vala
    pkg-config
    itstool
    gettext
    desktop-file-utils
    gtk3.wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libexif
    libgphoto2
    libwebp
    libsoup_3
    libxml2
    sqlite
    gstreamer
    gstreamer.libav
    gstreamer.plugins-base
    gstreamer.plugins-good
    libgee
    libgudev
    gexiv2
    gsettings-desktop-schemas
    libraw
    json-glib
    glib
    glib-networking
    gdk-pixbuf
    librsvg
    gcr_3
    adwaita-icon-theme
    libsecret
    libportal-gtk3
  ];

  meta = {
    description = "Popular photo organizer for the GNOME desktop";
    mainProgram = "shotwell";
    homepage = "https://gitlab.gnome.org/GNOME/shotwell";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
