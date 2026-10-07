{
  lib,
  stdenv,
  fetchFromGitHub,
  docbook-xml-dtd,
  docbook-xsl,
  gdk-pixbuf,
  gettext,
  glib,
  gperf,
  gtk-doc,
  json-glib,
  libarchive,
  curl,
  libuuid,
  libxslt,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appstream-glib";
  version = "0.8.3";

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    tag = "appstream_glib_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-GjXrYV+EBduhG88LaxQWICKuUDJeeotcZgqgaG0/dqo=";
  };

  nativeBuildInputs = [
    docbook-xml-dtd.v4_2
    docbook-xsl
    gettext
    gperf
    gtk-doc
    libxslt
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    json-glib
    libarchive
    curl
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
  ];

  mesonEntries = {
    rpm = false;
    dep11 = false;
    introspection = false;
    builder = false;
    fonts = false;
  };

  doCheck = false;

  meta = {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = "https://people.freedesktop.org/~hughsient/appstream-glib/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
