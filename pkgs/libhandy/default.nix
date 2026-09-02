{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhandy";
  version = "1.8.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libhandy/${lib.versions.majorMinor finalAttrs.version}/libhandy-${finalAttrs.version}.tar.xz";
    hash = "sha256-BbSXIpBz/1V/ELMm4HTFBm+HQ6MC1IIKuXvLXNLasIc=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    gtk3
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "gtk_doc" false)
    (lib.mesonEnable "glade_catalog" false)
    (lib.mesonEnable "introspection" false)
    (lib.mesonBool "vapi" false)
    (lib.mesonBool "tests" false)
    (lib.mesonBool "examples" false)
  ];

  doCheck = false;

  meta = {
    description = "Building blocks for modern adaptive GNOME apps";
    homepage = "https://gitlab.gnome.org/GNOME/libhandy";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
