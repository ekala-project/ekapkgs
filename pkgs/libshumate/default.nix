{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  gperf,
  glib,
  cairo,
  sqlite,
  libsoup_3,
  gtk4,
  json-glib,

  gi-docgen,
  libsysprof-capture,
  protobufc,
  # TODO: xvfb-run - not available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libshumate";
  version = "1.6.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libshumate/${lib.versions.majorMinor finalAttrs.version}/libshumate-${finalAttrs.version}.tar.xz";
    hash = "sha256-/RXJE5bc2C/OMCFkhUGqiR5xpr3e/8A9OFl1gKfajKE=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    gperf
  ];

  buildInputs = [
    glib
    cairo
    sqlite
    libsoup_3
    gtk4
    libsysprof-capture
    json-glib
    protobufc
  ];

  mesonFlags = [
    "-Ddemos=false"
    "-Dgtk_doc=true"
    "-Dsysprof=enabled"
  ];

  doCheck = false;

  strictDeps = true;

  meta = {
    description = "GTK toolkit providing widgets for embedded maps";
    homepage = "https://gitlab.gnome.org/GNOME/libshumate";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
