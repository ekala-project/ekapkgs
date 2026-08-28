{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  gtk-doc,
  docbook-xsl-nons,
  gobject-introspection,
  libsoup,
  json-glib,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geocode-glib";
  version = "3.26.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${lib.versions.majorMinor finalAttrs.version}/geocode-glib-${finalAttrs.version}.tar.xz";
    sha256 = "LZpoJtFYRwRJoXOHEiFZbaD4Pr3P+YuQxwSQiQVqN6o=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    gettext
    gtk-doc
    docbook-xsl-nons
    gobject-introspection
  ];

  buildInputs = [
    glib
    libsoup
    json-glib
  ];

  mesonFlags = [
    "-Dsoup2=false"
    "-Denable-installed-tests=false"
    "-Denable-introspection=false"
    "-Denable-gtk-doc=false"
  ];

  meta = {
    description = "Convenience library for geocoding and reverse geocoding using Nominatim service";
    homepage = "https://gitlab.gnome.org/GNOME/geocode-glib";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
