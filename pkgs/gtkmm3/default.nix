{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  gtk3,
  glibmm,
  cairomm,
  pangomm,
  atkmm,
  libepoxy,
  glib,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkmm";
  version = "3.24.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtkmm/${lib.versions.majorMinor finalAttrs.version}/gtkmm-${finalAttrs.version}.tar.xz";
    sha256 = "erfiJmgIcW4mw5kkrOH7RtqGwX7znZiWJMQjFLMrWnY=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
    python3
    glib
    gdk-pixbuf
  ];

  buildInputs = [ libepoxy ];

  propagatedBuildInputs = [
    glibmm
    gtk3
    atkmm
    cairomm
    pangomm
  ];

  doCheck = false;

  meta = {
    description = "C++ interface to the GTK graphical user interface library";
    homepage = "https://gtkmm.gnome.org/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
})
