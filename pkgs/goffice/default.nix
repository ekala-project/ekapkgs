{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  intltool,
  glib,
  gtk3,
  lasem,
  libgsf,
  libxml2,
  libxslt,
  cairo,
  pango,
  librsvg,
  autoreconfHook,
  gtk-doc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goffice";
  version = "0.10.59";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/${lib.versions.majorMinor finalAttrs.version}/goffice-${finalAttrs.version}.tar.xz";
    hash = "sha256-sI9xczJVlLcfu+pHajC1sxIMPa3/XAom0UDk5SSRZiI=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    autoreconfHook
    gtk-doc
    glib # for glib-genmarshal
  ];

  propagatedBuildInputs = [
    glib
    gtk3
    libxml2
    cairo
    pango
    libgsf
    lasem
  ];

  buildInputs = [
    libxslt
    librsvg
  ];

  configureFlags = [
    "--disable-introspection"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Glib/GTK set of document centric objects and utilities";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
