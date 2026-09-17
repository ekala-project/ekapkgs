{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  glib,
  json-glib,
  gobject-introspection,
  librest,
  gnome-online-accounts,
  libsoup_2_4,
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
    gnome-online-accounts
  ];

  propagatedBuildInputs = [
    libsoup_2_4
    json-glib
    librest
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
