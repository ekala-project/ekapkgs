{
  lib,
  stdenv,
  fetchurl,
  ninja,
  meson,
  pkg-config,
  libxml2,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_43,
  glib,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "libdazzle";
  version = "3.44.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libdazzle/${lib.versions.majorMinor version}/libdazzle-${version}.tar.xz";
    sha256 = "PNPkXrbiaAywXVLh6A3Y+dWdR2UhLw4o945sF4PRjq4=";
  };

  nativeBuildInputs = [
    ninja
    meson
    meson.configurePhaseHook
    pkg-config
    libxml2
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    glib
  ];

  buildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Denable_gtk_doc=false"
    "-Dwith_introspection=false"
    "-Dwith_vapi=false"
  ];

  doCheck = false;

  meta = {
    description = "Library to delight your users with fancy features";
    mainProgram = "dazzle-list-counters";
    homepage = "https://gitlab.gnome.org/GNOME/libdazzle";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
