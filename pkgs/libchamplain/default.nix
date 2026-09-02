{
  fetchurl,
  lib,
  stdenv,
  meson,
  ninja,
  vala,
  pkg-config,
  glib,
  gtk3,
  cairo,
  sqlite,
  libsoup_3,
  gobject-introspection,
  clutter,

  # TODO: not yet available in ekapkgs
  # clutter-gtk,
  # gtk-doc,
  # docbook_xsl,
  # docbook_xml_dtd_412,
}:

stdenv.mkDerivation rec {
  pname = "libchamplain";
  version = "0.12.21";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "qRXNFyoMUpRMVXn8tGg/ioeMVxv16SglS12v78cn5ac=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
  ];

  buildInputs = [
    sqlite
    libsoup_3
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    cairo
    # TODO: clutter-gtk not available — using clutter directly for now
    # clutter-gtk
    clutter
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
    "-Dvapi=true"
    (lib.mesonBool "libsoup3" true)
  ];

  meta = {
    description = "C library providing a ClutterActor to display maps";
    homepage = "https://gitlab.gnome.org/GNOME/libchamplain";
    license = lib.licenses.lgpl2Plus;
    longDescription = ''
      libchamplain is a C library providing a ClutterActor to display
       maps.  It also provides a GTK widget to display maps in GTK
       applications.  Python and Perl bindings are also available.  It
       supports numerous free map sources such as OpenStreetMap,
       OpenCycleMap, OpenAerialMap, and Maps for free.
    '';
    platforms = lib.platforms.unix;
  };
}
