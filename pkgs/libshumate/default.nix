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

  # TODO: not yet available in ekapkgs
  # gi-docgen,
  # libsysprof-capture,
  # protobufc,
  # xvfb-run,
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
    # TODO: gi-docgen not available — disable docs
    # gi-docgen
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
    # TODO: libsysprof-capture not available
    # libsysprof-capture
    json-glib
    # TODO: protobufc (protobuf-c) not available
    # protobufc
  ];

  mesonFlags = [
    "-Ddemos=false"
    "-Dgtk_doc=false"
    # TODO: re-enable sysprof once libsysprof-capture available
    "-Dsysprof=disabled"
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
