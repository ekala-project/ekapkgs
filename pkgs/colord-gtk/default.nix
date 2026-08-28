{
  lib,
  stdenv,
  fetchurl,
  colord,
  gettext,
  meson,
  ninja,
  gtk-doc,
  docbook-xsl-ns,
  docbook-xsl-nons,
  docbook_xml_dtd_412,
  libxslt,
  glib,
  gtk3,
  pkg-config,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "colord-gtk";
  version = "0.3.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/colord-gtk-${version}.tar.xz";
    sha256 = "wXa4ibdWMKF/Tj1+8kwJo+EjaOYzSWCHRZyLU6w6Ei0=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    meson.configurePhaseHook
    ninja
    gtk-doc
    docbook-xsl-ns
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxslt
  ];

  buildInputs = [
    glib
    lcms2
  ];

  propagatedBuildInputs = [
    colord
    gtk3
  ];

  mesonFlags = [
    "-Dgtk4=false"
    "-Dgtk3=true"
    "-Dintrospection=false"
    "-Dvapi=false"
  ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/colord/intro.html";
    description = "GTK integration for colord color management";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    mainProgram = "cd-convert";
  };
}
