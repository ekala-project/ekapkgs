{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  glib,
  gdk-pixbuf,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmediaart";
  version = "1.9.7";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/${lib.versions.majorMinor finalAttrs.version}/libmediaart-${finalAttrs.version}.tar.xz";
    sha256 = "K0Pdn1Tw2NC4nirduDNBqwbXuYyxsucEODWEr5xWD2s=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    gobject-introspection
  ];

  buildInputs = [
    glib
    gdk-pixbuf
  ];

  mesonFlags = [
    "-Dgtk_doc=false"
  ];

  meta = {
    description = "Library tasked with managing, extracting and handling media art caches";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
