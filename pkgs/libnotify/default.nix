{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libxslt,
  docbook-xsl-ns,
  glib,
  gdk-pixbuf,
}:

stdenv.mkDerivation rec {
  pname = "libnotify";
  version = "0.8.6";

  outputs = [
    "out"
    "man"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-xVQKrvtg4dY7HFh8BfIoTr5y7OfQwOXkp3jP1YRLa1g=";
  };

  mesonFlags = [
    "-Dtests=false"
    "-Ddocbook_docs=disabled"
    "-Dgtk_doc=false"
    "-Dintrospection=disabled"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    libxslt
    docbook-xsl-ns
    glib
  ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
  ];

  meta = {
    description = "Library that sends desktop notifications to a notification daemon";
    homepage = "https://gitlab.gnome.org/GNOME/libnotify";
    license = lib.licenses.lgpl21;
    mainProgram = "notify-send";
    platforms = lib.platforms.unix;
  };
}
