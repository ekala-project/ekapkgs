{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  glib,
  json-glib,
  gobject-introspection,

  # TODO: not yet available in ekapkgs
  # librest (being ported),
  # gnome-online-accounts (being ported),
  # libsoup_2_4 — this package needs libsoup 2.x, not libsoup 3
}:

stdenv.mkDerivation rec {
  pname = "gfbgraph";
  version = "0.2.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nLOBs/eLoRNt+Xrz8G47EdzCqzOawI907aD4BX1mA+M=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    # TODO: gnome-online-accounts (being ported)
    # gnome-online-accounts
  ];

  propagatedBuildInputs = [
    # TODO: libsoup_2_4 — this package uses libsoup 2.x API
    # libsoup_2_4
    json-glib
    # TODO: librest (being ported)
    # librest
  ];

  configureFlags = [
    "--enable-introspection"
    "--disable-gtk-doc"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GLib/GObject wrapper for the Facebook Graph API";
    homepage = "https://gitlab.gnome.org/GNOME/libgfbgraph";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
