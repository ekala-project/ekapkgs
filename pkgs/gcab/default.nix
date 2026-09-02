{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gobject-introspection,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcab";
  version = "1.6";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/${lib.versions.majorMinor finalAttrs.version}/gcab-${finalAttrs.version}.tar.xz";
    hash = "sha256-LwyWFVd8QSaQniUfneBibD7noVI3bBW1VE3xD8h+Vgs=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    vala
    gettext
    gobject-introspection
  ];

  buildInputs = [
    glib
    zlib
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFlags = [
    "-Dinstalled_tests=false"
    "-Ddocs=false"
  ];

  doCheck = true;

  meta = {
    description = "GObject library to create cabinet files";
    mainProgram = "gcab";
    homepage = "https://gitlab.gnome.org/GNOME/gcab";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
